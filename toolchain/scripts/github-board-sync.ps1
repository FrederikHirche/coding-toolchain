<#
.SYNOPSIS
Synchronisiert Tool-Chain-Artefakte (US/BUG/DEBT/IMPD/EPIC) mit einem GitHub Project (v2) Board.

.DESCRIPTION
Implementiert toolchain/protocols/github-board-sync.md. Best-effort, nie blockierend:
fehlt `gh`, Auth oder Board-Konfiguration, wird der Sync ohne Fehlercode übersprungen.
Nutzt ausschließlich die `gh`-CLI — kein eigener GraphQL-Client.

Synchronisiert den GESAMTEN Backlog (nicht nur den laufenden Sprint): Status, Estimate,
Size, Priority, Iteration, Start-/Zieldatum, Milestone (aus EPIC-NNNNNN) sowie eine
vollständig aus dem Artefakt gerenderte Issue-Beschreibung inkl. Akzeptanzkriterien.

.PARAMETER ProjectPath
Pfad zu projects/<name> (enthält .toolchain.yml, .phase, INDEX.md).

.PARAMETER Mode
'push'      — Tool Chain → GitHub (Issues/Milestones anlegen/aktualisieren, IDs zurückschreiben)
'reconcile' — GitHub → Tool Chain (Board-Stand lesen, Konfliktregel anwenden, nur melden)
#>

param(
    [Parameter(Mandatory = $true)]
    [string] $ProjectPath,

    [Parameter(Mandatory = $true)]
    [ValidateSet('push', 'reconcile')]
    [string] $Mode
)

$ErrorActionPreference = 'Stop'

function Write-SyncInfo([string] $Message) { Write-Host "[github-board-sync] $Message" }
function Write-SyncWarn([string] $Message) { Write-Warning "[github-board-sync] $Message" }

function Get-ToolchainConfig([string] $ConfigPath) {
    if (-not (Test-Path -LiteralPath $ConfigPath)) { return $null }
    $text = Get-Content -LiteralPath $ConfigPath -Raw

    function Get-Scalar([string] $Key) {
        $m = [regex]::Match($text, "(?m)^\s{2}${Key}:\s*(.+?)\s*(#.*)?$")
        if ($m.Success) { return $m.Groups[1].Value.Trim() }
        return $null
    }

    $enabledRaw = Get-Scalar 'enabled'
    [PSCustomObject]@{
        Enabled             = ($enabledRaw -eq 'true')
        Repo                = (Get-Scalar 'repo') -replace '^~$', $null
        ProjectNumber       = (Get-Scalar 'project-number') -replace '^~$', $null
        AuthMode            = (Get-Scalar 'auth-mode') -replace '^~$', 'gh-cli'
        AuthEnvVar          = (Get-Scalar 'auth-env-var') -replace '^~$', $null
        IterationLengthDays = (Get-Scalar 'iteration-length-days') -replace '^~$', '14'
        IterationStartDate  = (Get-Scalar 'iteration-start-date') -replace '^~$', $null
        IterationStartSprint = (Get-Scalar 'iteration-start-sprint') -replace '^~$', '1'
    }
}

function Test-GhReady([PSCustomObject] $Config) {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-SyncWarn "gh-CLI nicht installiert — Sync übersprungen. Siehe cli.github.com."
        return $false
    }
    if ($Config.AuthMode -eq 'env-var') {
        if (-not $Config.AuthEnvVar -or -not (Test-Path "env:$($Config.AuthEnvVar)")) {
            Write-SyncWarn "Environment-Variable '$($Config.AuthEnvVar)' nicht gesetzt — Sync übersprungen."
            return $false
        }
        $env:GH_TOKEN = (Get-Item "env:$($Config.AuthEnvVar)").Value
        return $true
    }
    $status = (& gh auth status --hostname github.com 2>&1) -join "`n"
    if ($LASTEXITCODE -ne 0) {
        Write-SyncWarn "gh nicht authentifiziert — bitte 'gh auth login --scopes project,repo' selbst ausführen. Sync übersprungen."
        return $false
    }
    if ($status -notmatch 'project') {
        Write-SyncWarn "gh-Token ohne 'project'-Scope — bitte 'gh auth refresh --scopes project,repo' ausführen. Sync übersprungen."
        return $false
    }
    return $true
}

function Get-BoardStatus([string] $ArtifactType, [string] $ArtifactStatus, [string] $CurrentPhase, [string] $StorySprint, [string] $CurrentSprint) {
    switch ($ArtifactType) {
        'BUG' {
            switch ($ArtifactStatus) {
                'OFFEN' { return 'Backlog' }
                'IN_BEARBEITUNG' { return 'In Progress' }
                'BEHOBEN' { return 'In Review' }
                'VERIFIZIERT' { return 'Done' }
                default { return 'Backlog' }
            }
        }
        'DEBT' {
            switch ($ArtifactStatus) {
                'OFFEN' { return 'Backlog' }
                'IN BEARBEITUNG' { return 'In Progress' }
                'RESOLVED' { return 'Done' }
                default { return 'Backlog' }
            }
        }
        'IMPD' {
            switch ($ArtifactStatus) {
                'DRAFT' { return 'Backlog' }
                'ACTIVE' { return 'In Progress' }
                'RESOLVED' { return 'Done' }
                default { return 'Backlog' }
            }
        }
        default {
            # US-NNNNNN: kein eigener Fortschrittsstatus — abgeleitet aus Projektphase, ABER
            # nur für die Story, die tatsächlich im aktuell laufenden Sprint steckt. Ohne diese
            # Eingrenzung würde JEDE Story beim nächsten Phasenwechsel (z. B. neues /refine)
            # denselben global abgeleiteten Status erhalten — ein längst fertiges US-NNNNNN aus
            # Sprint 1 würde durch einen späteren /refine-Aufruf fälschlich auf 'Backlog'
            # zurückgesetzt, obwohl es nie wieder angefasst wurde.
            if (-not $CurrentSprint -or $StorySprint -ne $CurrentSprint) { return $null }
            switch -Regex ($CurrentPhase) {
                'REVIEW|DOCUMENTATION|DONE|RELEASED' { return 'Done' }
                'IMPLEMENTATION|TESTING' { return 'In Progress' }
                default { return 'Backlog' }
            }
        }
    }
}

function Get-BoardPriority([string] $ArtifactType, [PSCustomObject] $Fields) {
    if ($ArtifactType -eq 'BUG') {
        switch ($Fields.severity) {
            'BLOCKER' { return 'P0' }
            'MAJOR' { return 'P1' }
            'MINOR' { return 'P2' }
            default { return $null }
        }
    }
    switch ($Fields.priority) {
        'Must' { return 'P0' }
        'Should' { return 'P1' }
        'Could' { return 'P2' }
        "Won't" { return 'P3' }
        default { return $null }
    }
}

function Get-Frontmatter([string] $FilePath) {
    $text = Get-Content -LiteralPath $FilePath -Raw
    $m = [regex]::Match($text, "(?s)^---\r?\n(.*?)\r?\n---")
    if (-not $m.Success) { return $null }
    $fields = @{}
    foreach ($line in ($m.Groups[1].Value -split "`n")) {
        $kv = [regex]::Match($line, "^([\w-]+):\s*(.+?)\s*(#.*)?$")
        if ($kv.Success) { $fields[$kv.Groups[1].Value] = $kv.Groups[2].Value.Trim() }
    }
    [PSCustomObject]@{ Fields = $fields; FullText = $text }
}

function Set-FrontmatterField([string] $FilePath, [string] $Key, [string] $Value) {
    $text = Get-Content -LiteralPath $FilePath -Raw
    $pattern = "(?m)^${Key}:\s*.*$"
    if ($text -match $pattern) {
        $newText = $text -replace $pattern, "$Key`: $Value"
    } else {
        $newText = $text -replace "(?s)^(---\r?\n.*?)\r?\n---", "`$1`n$Key`: $Value`n---"
    }
    Set-Content -LiteralPath $FilePath -Value $newText -NoNewline
}

# ── Issue-Body-Rendering ─────────────────────────────────────────────────
# Sektionen der Templates sind durch Zeilen mit ausschließlich "---" getrennt (siehe
# toolchain/templates/*.md). Das erlaubt robustes Extrahieren ohne pro Typ hartkodierte
# Zeilennummern — funktioniert auch wenn Nutzer eigene Unterabschnitte ergänzen.

function Get-BodySections([string] $Text) {
    $body = $Text -replace '(?s)^---\r?\n.*?\r?\n---\r?\n', ''
    return ($body -split '(?m)^---\s*$')
}

function Get-SectionByMarker([string[]] $Sections, [string] $Marker) {
    $hit = $Sections | Where-Object { $_ -match [regex]::Escape($Marker) } | Select-Object -First 1
    if ($hit) { return $hit.Trim() }
    return $null
}

function Format-MetaFooter([PSCustomObject] $Fields, [string] $ArtifactType) {
    $lines = @('', '---', '', '**Tool-Chain-Metadaten** _(automatisch synchronisiert — Änderungen bitte in der Quelldatei vornehmen)_', '')
    $priority = if ($ArtifactType -eq 'BUG') { $Fields.severity } else { $Fields.priority }
    if ($priority) { $lines += "- Priorität/Schweregrad: $priority" }
    if ($Fields.estimate -and $Fields.estimate -ne '—') { $lines += "- Estimate: $($Fields.estimate) Story Points" }
    if ($Fields.size -and $Fields.size -ne '—') { $lines += "- Size: $($Fields.size)" }
    if ($Fields.iteration -and $Fields.iteration -ne '—') { $lines += "- Geplante Iteration: Sprint $($Fields.iteration)" }
    if ($Fields.'start-date' -and $Fields.'start-date' -ne '—') { $lines += "- Start: $($Fields.'start-date')" }
    if ($Fields.'target-date' -and $Fields.'target-date' -ne '—') { $lines += "- Ziel: $($Fields.'target-date')" }
    if ($Fields.epic -and $Fields.epic -ne '—') { $lines += "- Epic: $($Fields.epic)" }
    return ($lines -join "`n")
}

function Format-IssueTitle([string] $ArtifactType, [string] $Id, [string] $Title) {
    # Issue-Titel tragen die Artefakt-ID (z. B. "US-000067: ..."), nicht nur den generischen
    # Typ-Präfix ("US: ...") — sonst ist auf dem Board keine direkte Zuordnung zur Codebase
    # (Dateiname/Frontmatter-ID) ohne Öffnen des Issues möglich.
    $displayTitle = $Title
    if ($ArtifactType -eq 'BUG' -and $displayTitle -match '^Bug\s*[—-]\s*(.+)$') {
        # BUG-Frontmatter-Titel beginnen selbst mit "Bug — ..." (Bug-Report-Template) — das
        # ist redundant, sobald die ID bereits "BUG-NNNNNN" im Titel-Präfix trägt.
        $displayTitle = $Matches[1]
    }
    $prefix = if ($Id -and $Id -ne '—') { $Id } else { $ArtifactType }
    return "$prefix`: $displayTitle"
}

function Format-IssueBody([string] $ArtifactType, [string] $FilePath, [PSCustomObject] $Fm) {
    $sections = Get-BodySections $Fm.FullText
    $parts = @("_Synchronisiert aus ``$FilePath`` — wird bei jedem Sync-Lauf überschrieben._", '')

    switch ($ArtifactType) {
        'US' {
            $story = Get-SectionByMarker $sections '## User Story'
            $ac = Get-SectionByMarker $sections '## Akzeptanzkriterien'
            $nonGoals = Get-SectionByMarker $sections '## Nicht-Ziele dieser Story'
            $deps = Get-SectionByMarker $sections '## Abhängigkeiten'
            if ($story) { $parts += $story; $parts += '' }
            if ($ac) { $parts += $ac; $parts += '' }
            if ($nonGoals) { $parts += $nonGoals; $parts += '' }
            if ($deps) { $parts += $deps; $parts += '' }
        }
        'BUG' {
            $symptom = Get-SectionByMarker $sections '## 1. Symptom'
            $repro = Get-SectionByMarker $sections '## 2. Reproduktionsschritte'
            $severity = Get-SectionByMarker $sections '## 3. Schweregrad'
            if ($symptom) { $parts += $symptom; $parts += '' }
            if ($repro) { $parts += $repro; $parts += '' }
            if ($severity) { $parts += $severity; $parts += '' }
        }
        'IMPD' {
            $summary = Get-SectionByMarker $sections '## Zusammenfassung'
            $diagnose = Get-SectionByMarker $sections '## Diagnose'
            if ($summary) { $parts += $summary; $parts += '' }
            if ($diagnose) { $parts += $diagnose; $parts += '' }
        }
        'DEBT' {
            # $FilePath zeigt hier auf die DEBT-REGISTRY-Datei; der Detail-Abschnitt wird
            # separat übergeben (siehe Sync-DebtRegistry) und direkt angehängt.
        }
    }
    $parts += Format-MetaFooter $Fm.Fields $ArtifactType
    return ($parts -join "`n")
}

# ── Relationships (Blocks/Blocked-by) ────────────────────────────────────
# Best-effort über die GitHub-Issue-Dependencies-API (nicht auf jedem Plan/Repo verfügbar).
# Garantierter Fallback ist der unveränderte "## Abhängigkeiten"-Tabellentext im Issue-Body
# (siehe Format-IssueBody) — ein Fehlschlag hier ist erwartet und nie ein Fehler.

function Resolve-ArtifactIssueNumber([string] $ArtifactId, [string] $ProjectPath) {
    if (-not $ArtifactId -or $ArtifactId -match '^ADR-') { return $null }
    foreach ($sub in @('requirements', 'testing', 'retros')) {
        $f = Get-ChildItem -Path (Join-Path $ProjectPath "$sub/$ArtifactId*.md") -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($f) {
            $fm = Get-Frontmatter $f.FullName
            if ($fm -and $fm.Fields['github-issue'] -and $fm.Fields['github-issue'] -ne '—') {
                return $fm.Fields['github-issue']
            }
        }
    }
    return $null
}

function Get-DependencyRows([string] $DependencySection) {
    $rows = @()
    if (-not $DependencySection) { return $rows }
    foreach ($line in ($DependencySection -split "`n")) {
        $m = [regex]::Match($line, '^\|\s*(Blockiert durch|Blockiert)\s*\|\s*([A-Z]+-\d+)\s*\|')
        if ($m.Success) { $rows += [PSCustomObject]@{ Type = $m.Groups[1].Value; Ref = $m.Groups[2].Value } }
    }
    return $rows
}

function Sync-IssueDependencies {
    param([string] $IssueNumber, [string] $DependencySection, [PSCustomObject] $Config, [string] $ProjectPath)
    if (-not $IssueNumber -or -not $DependencySection) { return }
    foreach ($row in (Get-DependencyRows $DependencySection)) {
        $refIssue = Resolve-ArtifactIssueNumber $row.Ref $ProjectPath
        if (-not $refIssue) { continue }
        if ($row.Type -eq 'Blockiert durch') {
            & gh api "repos/$($Config.Repo)/issues/$IssueNumber/dependencies/blocked_by" -f "issue_id=$refIssue" 2>$null | Out-Null
        } else {
            & gh api "repos/$($Config.Repo)/issues/$refIssue/dependencies/blocked_by" -f "issue_id=$IssueNumber" 2>$null | Out-Null
        }
    }
}

# ── Board-Feld-Auflösung ─────────────────────────────────────────────────
# gh project item-edit verlangt GraphQL-Node-IDs für --id/--field-id/--single-select-option-id/
# --iteration-id, keine Klartext-Namen und keine Issue-Nummer. Diese IDs werden einmal pro
# Lauf aufgelöst und über die Sync-Funktionen hinweg zwischengespeichert.

function Get-BoardContext([PSCustomObject] $Config) {
    $ctx = [PSCustomObject]@{
        Owner              = ($Config.Repo -split '/')[0]
        ProjectId          = $null
        FieldsByName       = @{}
        ItemsByIssue       = @{}
        MilestonesByTitle  = @{}
        MilestonesByNumber = @{}
        IterationCycles    = @()
    }
    if (-not $Config.ProjectNumber) { return $ctx }

    $projView = & gh project view $Config.ProjectNumber --owner $ctx.Owner --format json 2>$null
    if ($LASTEXITCODE -eq 0 -and $projView) { $ctx.ProjectId = ($projView | ConvertFrom-Json).id }

    $fieldList = & gh project field-list $Config.ProjectNumber --owner $ctx.Owner --format json 2>$null
    if ($LASTEXITCODE -eq 0 -and $fieldList) {
        foreach ($field in ($fieldList | ConvertFrom-Json).fields) {
            $ctx.FieldsByName[$field.name] = $field
        }
    }
    foreach ($required in @('Status', 'Estimate', 'Size', 'Priority', 'Iteration', 'Start date', 'Target date')) {
        if (-not $ctx.FieldsByName.ContainsKey($required)) {
            Write-SyncWarn "Board-Feld '$required' nicht gefunden — zugehörige Updates werden für diesen Lauf übersprungen."
        }
    }

    # `gh project field-list` liefert für ein ProjectV2IterationField KEINE
    # `configuration.iterations`/`completedIterations` (anders als bei Single-Select-Feldern
    # mit `.options`) — bestätigt gegen die reale API, nicht nur vermutet (IMPD-000001). Ohne
    # diesen zusätzlichen GraphQL-Aufruf bleibt das Iteration-Feld für IMMER unbefüllt, egal
    # welcher Wert in der Frontmatter steht — kein Board-Konfigurationsfehler, sondern eine
    # `gh`-CLI-Lücke, die ein direkter `node(id:)`-Query auf die Feld-ID schließt.
    $ctx.IterationCycles = @()
    if ($ctx.FieldsByName.ContainsKey('Iteration')) {
        $iterationFieldId = $ctx.FieldsByName['Iteration'].id
        $query = 'query($fieldId: ID!) { node(id: $fieldId) { ... on ProjectV2IterationField { configuration { iterations { id title startDate duration } completedIterations { id title startDate duration } } } } }'
        $iterResult = & gh api graphql -f query=$query -f fieldId=$iterationFieldId 2>$null
        if ($LASTEXITCODE -eq 0 -and $iterResult) {
            # NIE "$config" nennen — PowerShell-Variablennamen sind case-insensitiv, das würde
            # den Funktionsparameter "$Config" (ProjectNumber/Repo/...) überschreiben und jeden
            # nachfolgenden Aufruf in dieser Funktion (item-list, milestones) stillschweigend
            # brechen (gefunden während IMPD-000001-Fix — exakt dieser Fehler trat live auf).
            $iterConfiguration = ($iterResult | ConvertFrom-Json).data.node.configuration
            $ctx.IterationCycles = @(@($iterConfiguration.iterations) + @($iterConfiguration.completedIterations) | Where-Object { $_ } | Sort-Object startDate)
        }
    }

    $itemList = & gh project item-list $Config.ProjectNumber --owner $ctx.Owner --format json --limit 500 2>$null
    if ($LASTEXITCODE -eq 0 -and $itemList) {
        foreach ($item in ($itemList | ConvertFrom-Json).items) {
            if ($item.content -and $item.content.number) { $ctx.ItemsByIssue["$($item.content.number)"] = $item.id }
        }
    }

    $milestones = & gh api "repos/$($Config.Repo)/milestones" --paginate 2>$null
    if ($LASTEXITCODE -eq 0 -and $milestones) {
        foreach ($ms in ($milestones | ConvertFrom-Json)) {
            $ctx.MilestonesByTitle[$ms.title] = $ms.number
            $ctx.MilestonesByNumber["$($ms.number)"] = $ms.title
        }
    }
    return $ctx
}

function Resolve-SingleSelectOptionId([PSCustomObject] $Field, [string] $Value) {
    if (-not $Field -or -not $Value) { return $null }
    $opt = $Field.options | Where-Object { $_.name -eq $Value } | Select-Object -First 1
    if (-not $opt) { $opt = $Field.options | Where-Object { $_.name -like "*$Value*" } | Select-Object -First 1 }
    if ($opt) { return $opt.id }
    return $null
}

$StatusAliases = @{
    'Backlog'     = @('Backlog', 'Todo', 'To Do', 'Open')
    'In Progress' = @('In Progress', 'Doing', 'Active')
    'In Review'   = @('In Review', 'Review', 'In Progress')
    'Done'        = @('Done', 'Closed', 'Complete')
}

function Resolve-StatusOptionId([PSCustomObject] $Field, [string] $Value) {
    # Boards mit den GitHub-Standardoptionen (Todo/In Progress/Done, keine Backlog/In Review)
    # sollen trotzdem eine sinnvolle Zuordnung erhalten statt das Status-Update stumm zu
    # überspringen — Alias-Kette in absteigender Präferenz, erster Treffer gewinnt.
    if (-not $Field -or -not $Value -or -not $StatusAliases.ContainsKey($Value)) { return $null }
    foreach ($alias in $StatusAliases[$Value]) {
        $opt = $Field.options | Where-Object { $_.name -eq $alias } | Select-Object -First 1
        if ($opt) { return $opt.id }
    }
    return $null
}

function Resolve-IterationId {
    param([PSCustomObject] $Board, [PSCustomObject] $Config, [string] $IterationNumber)
    if (-not $IterationNumber) { return $null }
    $sorted = $Board.IterationCycles
    if (-not $sorted -or $sorted.Count -eq 0) { return $null }

    # Board-Iteration-Zyklen sind datumsbasiert und laufen ab `iteration-start-date` (welches
    # `iteration-start-sprint` entspricht) — NICHT ab Sprint 1 durchnummeriert. Ein Sprint auf
    # dem Board, dessen Zyklen z. B. erst ab Sprint 16 provisioniert wurden, würde bei reiner
    # 1-basierter Index-Zählung (Sprint 16 → 16. Zyklus) weit über die tatsächlich
    # materialisierten Zyklen hinausgreifen. Stattdessen wird die Sprint-Nummer über die
    # konfigurierte Kadenz in ein Zieldatum übersetzt und der Zyklus gesucht, dessen
    # [startDate, startDate+duration)-Fenster dieses Datum enthält.
    $anchorDate = if ($Config.IterationStartDate) { [datetime]::Parse($Config.IterationStartDate) } else { Get-Date }
    $anchorSprint = [int]$Config.IterationStartSprint
    $lengthDays = [int]$Config.IterationLengthDays
    $offsetSprints = [int]$IterationNumber - $anchorSprint
    $targetDate = $anchorDate.AddDays($offsetSprints * $lengthDays)

    foreach ($cycle in $sorted) {
        $cycleStart = [datetime]::Parse($cycle.startDate)
        $cycleEnd = $cycleStart.AddDays([int]$cycle.duration)
        if ($targetDate -ge $cycleStart -and $targetDate -lt $cycleEnd) {
            return $cycle.id
        }
    }
    Write-SyncWarn "Iteration $IterationNumber (Zieldatum $($targetDate.ToString('yyyy-MM-dd'))) liegt außerhalb der auf dem Board materialisierten Zyklen — nächstliegende Iteration wird verwendet."
    $closest = $sorted | Sort-Object { [Math]::Abs(([datetime]::Parse($_.startDate) - $targetDate).TotalDays) } | Select-Object -First 1
    return $closest.id
}

function Set-BoardFieldValue {
    param([PSCustomObject] $Board, [PSCustomObject] $Config, [string] $ItemId, [string] $FieldName, [string] $Value, [string] $ValueType)
    if (-not $ItemId -or -not $Value -or $Value -eq '—') { return }
    $field = $Board.FieldsByName[$FieldName]
    if (-not $field) { return }

    $ghArgs = @('project', 'item-edit', '--id', $ItemId, '--field-id', $field.id, '--project-id', $Board.ProjectId)
    switch ($ValueType) {
        'Number' { $ghArgs += @('--number', $Value) }
        'Date' { $ghArgs += @('--date', $Value) }
        'SingleSelect' {
            $optionId = if ($FieldName -eq 'Status') { Resolve-StatusOptionId $field $Value } else { $null }
            if (-not $optionId) { $optionId = Resolve-SingleSelectOptionId $field $Value }
            if (-not $optionId) {
                Write-SyncWarn "Keine passende Option '$Value' für Feld '$FieldName' gefunden — Update übersprungen."
                return
            }
            $ghArgs += @('--single-select-option-id', $optionId)
        }
        'Iteration' {
            $iterationId = Resolve-IterationId $Board $Config $Value
            if (-not $iterationId) { return }
            $ghArgs += @('--iteration-id', $iterationId)
        }
    }
    & gh @ghArgs 2>$null | Out-Null
}

function Get-BoardItemId {
    param([PSCustomObject] $Config, [PSCustomObject] $Board, [string] $IssueUrl, [string] $IssueNumber)
    if (-not $Config.ProjectNumber) { return $null }
    if ($IssueUrl) {
        $added = & gh project item-add $Config.ProjectNumber --owner $Board.Owner --url $IssueUrl --format json 2>$null
        if ($LASTEXITCODE -eq 0 -and $added) {
            $itemId = ($added | ConvertFrom-Json).id
            $Board.ItemsByIssue[$IssueNumber] = $itemId
            return $itemId
        }
        return $null
    }
    if ($Board.ItemsByIssue.ContainsKey($IssueNumber)) { return $Board.ItemsByIssue[$IssueNumber] }
    return $null
}

function Sync-EpicMilestone {
    param([string] $FilePath, [PSCustomObject] $Config, [PSCustomObject] $Board)

    $fm = Get-Frontmatter $FilePath
    if (-not $fm) { return }
    $title = $fm.Fields['title']
    $milestoneNumber = $fm.Fields['github-milestone']

    if (-not $milestoneNumber -or $milestoneNumber -eq '—') {
        if ($Board.MilestonesByTitle.ContainsKey($title)) {
            $milestoneNumber = $Board.MilestonesByTitle[$title]
        } else {
            $created = & gh api "repos/$($Config.Repo)/milestones" -f "title=$title" -f "description=Synchronisiert aus $FilePath" 2>$null
            if ($LASTEXITCODE -eq 0 -and $created) {
                $milestoneNumber = ($created | ConvertFrom-Json).number
                $Board.MilestonesByTitle[$title] = $milestoneNumber
                $Board.MilestonesByNumber["$milestoneNumber"] = $title
                Write-SyncInfo "Milestone '$title' angelegt (#$milestoneNumber) für $FilePath"
            }
        }
        if ($milestoneNumber) { Set-FrontmatterField -FilePath $FilePath -Key 'github-milestone' -Value $milestoneNumber }
    }
}

function Get-EpicMilestoneTitle {
    param([string] $EpicId, [string] $ProjectPath, [PSCustomObject] $Board)
    if (-not $EpicId -or $EpicId -eq '—') { return $null }
    $epicFile = Get-ChildItem -Path (Join-Path $ProjectPath "requirements/$EpicId*.md") -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $epicFile) { return $null }
    $fm = Get-Frontmatter $epicFile.FullName
    if (-not $fm) { return $null }
    $number = $fm.Fields['github-milestone']
    if ($number -and $number -ne '—' -and $Board.MilestonesByNumber.ContainsKey($number)) {
        return @{ Title = $Board.MilestonesByNumber[$number]; Number = $number }
    }
    return $null
}

function Sync-Artifact {
    param(
        [string] $FilePath,
        [string] $ArtifactType,
        [PSCustomObject] $Config,
        [PSCustomObject] $Board,
        [string] $CurrentPhase,
        [string] $CurrentSprint,
        [string] $Mode,
        [string] $ProjectPath
    )

    $fm = Get-Frontmatter $FilePath
    if (-not $fm) { return }

    $issueNumber = $fm.Fields['github-issue']
    $title = $fm.Fields['title']
    $artifactStatus = $fm.Fields['status']
    $boardStatus = Get-BoardStatus -ArtifactType $ArtifactType -ArtifactStatus $artifactStatus -CurrentPhase $CurrentPhase -StorySprint $fm.Fields['sprint'] -CurrentSprint $CurrentSprint

    if ($ArtifactType -eq 'IMPD' -and $artifactStatus -eq 'RESOLVED' -and (-not $issueNumber -or $issueNumber -eq '—')) {
        # Sofort gelöste Impediments erzeugen laut Protokoll kein Issue.
        return
    }

    if ($Mode -eq 'reconcile') {
        if (-not $issueNumber -or $issueNumber -eq '—') { return }
        if (-not $boardStatus) { return }
        $boardState = & gh issue view $issueNumber --repo $Config.Repo --json state,labels 2>$null | ConvertFrom-Json
        if (-not $boardState) { return }
        $expectedOpen = ($boardStatus -ne 'Done')
        $isOpen = ($boardState.state -eq 'OPEN')
        if ($expectedOpen -ne $isOpen) {
            Write-SyncWarn "Konflikt: $FilePath erwartet Board-Status '$boardStatus', Issue #$issueNumber steht auf '$($boardState.state)'. Tool-Chain-Gates gewinnen — Board wird beim nächsten push zurückgesetzt, keine automatische Übernahme."
        }
        return
    }

    # Mode: push
    $issueUrl = $null
    $bodyText = Format-IssueBody -ArtifactType $ArtifactType -FilePath $FilePath -Fm $fm
    $issueTitle = Format-IssueTitle -ArtifactType $ArtifactType -Id $fm.Fields['id'] -Title $title

    if (-not $issueNumber -or $issueNumber -eq '—') {
        $bodyFile = New-TemporaryFile
        Set-Content -LiteralPath $bodyFile -Value $bodyText -NoNewline
        $created = & gh issue create --repo $Config.Repo --title $issueTitle --body-file $bodyFile.FullName 2>&1
        Remove-Item -LiteralPath $bodyFile -ErrorAction SilentlyContinue
        if ($LASTEXITCODE -ne 0) {
            Write-SyncWarn "Issue-Erstellung fehlgeschlagen für $FilePath`: $created"
            return
        }
        $issueUrl = ($created | Select-String -Pattern 'https://\S+').Matches[0].Value
        $issueNumber = ($issueUrl -split '/')[-1]
        Set-FrontmatterField -FilePath $FilePath -Key 'github-issue' -Value $issueNumber
        Write-SyncInfo "Issue #$issueNumber angelegt für $FilePath"
    } else {
        $bodyFile = New-TemporaryFile
        Set-Content -LiteralPath $bodyFile -Value $bodyText -NoNewline
        & gh issue edit $issueNumber --repo $Config.Repo --title $issueTitle --body-file $bodyFile.FullName 2>$null | Out-Null
        Remove-Item -LiteralPath $bodyFile -ErrorAction SilentlyContinue
    }

    $epicRef = Get-EpicMilestoneTitle -EpicId $fm.Fields['epic'] -ProjectPath $ProjectPath -Board $Board
    if ($epicRef) {
        & gh issue edit $issueNumber --repo $Config.Repo --milestone $epicRef.Title 2>$null | Out-Null
        Set-FrontmatterField -FilePath $FilePath -Key 'github-milestone' -Value $epicRef.Number
    }

    if ($ArtifactType -eq 'US') {
        $depSection = Get-SectionByMarker (Get-BodySections $fm.FullText) '## Abhängigkeiten'
        Sync-IssueDependencies -IssueNumber $issueNumber -DependencySection $depSection -Config $Config -ProjectPath $ProjectPath
    }

    $itemId = Get-BoardItemId -Config $Config -Board $Board -IssueUrl $issueUrl -IssueNumber $issueNumber
    if ($itemId) {
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Status' -Value $boardStatus -ValueType 'SingleSelect'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Estimate' -Value $fm.Fields['estimate'] -ValueType 'Number'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Size' -Value $fm.Fields['size'] -ValueType 'SingleSelect'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Priority' -Value (Get-BoardPriority $ArtifactType $fm.Fields) -ValueType 'SingleSelect'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Iteration' -Value $fm.Fields['iteration'] -ValueType 'Iteration'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Start date' -Value $fm.Fields['start-date'] -ValueType 'Date'
        Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Target date' -Value $fm.Fields['target-date'] -ValueType 'Date'
    }
    $statusLabel = if ($boardStatus) { $boardStatus } else { 'unverändert (nicht im aktuellen Sprint)' }
    Write-SyncInfo "$FilePath → Issue #$issueNumber, Board-Status: $statusLabel"
}

function Sync-DebtRegistry {
    param(
        [string] $FilePath,
        [PSCustomObject] $Config,
        [PSCustomObject] $Board,
        [string] $Mode,
        [string] $ProjectPath
    )

    $lines = Get-Content -LiteralPath $FilePath
    # Muss die aktiv getrackte Registry-Tabelle treffen (Spalte "Status"), nicht die separate
    # "## Erledigte Schulden"-Verlaufstabelle (nur ID/Titel/Resolved in/Lösung, kein Status) —
    # sonst werden für längst abgeschlossene historische Einträge neue Issues angelegt.
    $headerMatch = $lines | Select-String -Pattern '^\|\s*ID\s*\|' | Where-Object { $_.Line -match '\|\s*Status\s*\|' } | Select-Object -First 1
    if (-not $headerMatch) { return }
    $headerIdx = $headerMatch.LineNumber - 1
    $columns = ($lines[$headerIdx] -split '\|') | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
    $changed = $false

    for ($i = $headerIdx + 2; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -notmatch '^\|\s*DEBT-\d+\s*\|') { break }
        $cells = ($lines[$i] -split '\|')
        $cells = $cells[1..($cells.Count - 2)] | ForEach-Object { $_.Trim() }
        if ($cells.Count -lt $columns.Count) { continue }

        $row = @{}
        for ($c = 0; $c -lt $columns.Count; $c++) { $row[$columns[$c]] = $cells[$c] }

        $id = $row['ID']
        $status = $row['Status']
        $issueNumber = $row['GitHub Issue']
        $boardStatus = Get-BoardStatus -ArtifactType 'DEBT' -ArtifactStatus $status -CurrentPhase ''

        if ($Mode -eq 'reconcile') {
            if (-not $issueNumber -or $issueNumber -eq '—') { continue }
            $boardState = & gh issue view $issueNumber --repo $Config.Repo --json state 2>$null | ConvertFrom-Json
            if (-not $boardState) { continue }
            $expectedOpen = ($boardStatus -ne 'Done')
            $isOpen = ($boardState.state -eq 'OPEN')
            if ($expectedOpen -ne $isOpen) {
                Write-SyncWarn "Konflikt: $id erwartet Board-Status '$boardStatus', Issue #$issueNumber steht auf '$($boardState.state)'. Tool-Chain-Gates gewinnen."
            }
            continue
        }

        # Mode: push
        $issueUrl = $null
        $detailFields = @{
            estimate = $row['Estimate']; size = $row['Size']; iteration = $row['Iteration']
            'start-date' = $row['Start']; 'target-date' = $row['Ziel']; epic = $row['Epic']
        }
        $bodyText = "_Synchronisiert aus ``$FilePath`` ($id) — wird bei jedem Sync-Lauf überschrieben._`n`n" + (Format-MetaFooter $detailFields 'DEBT')
        $issueTitle = Format-IssueTitle -ArtifactType 'DEBT' -Id $id -Title $row['Titel']

        if (-not $issueNumber -or $issueNumber -eq '—') {
            $bodyFile = New-TemporaryFile
            Set-Content -LiteralPath $bodyFile -Value $bodyText -NoNewline
            $created = & gh issue create --repo $Config.Repo --title $issueTitle --body-file $bodyFile.FullName 2>&1
            Remove-Item -LiteralPath $bodyFile -ErrorAction SilentlyContinue
            if ($LASTEXITCODE -ne 0) {
                Write-SyncWarn "Issue-Erstellung fehlgeschlagen für $id`: $created"
                continue
            }
            $issueUrl = ($created | Select-String -Pattern 'https://\S+').Matches[0].Value
            $issueNumber = ($issueUrl -split '/')[-1]
            $row['GitHub Issue'] = $issueNumber
            $changed = $true
            Write-SyncInfo "Issue #$issueNumber angelegt für $id"
        } else {
            $bodyFile = New-TemporaryFile
            Set-Content -LiteralPath $bodyFile -Value $bodyText -NoNewline
            & gh issue edit $issueNumber --repo $Config.Repo --title $issueTitle --body-file $bodyFile.FullName 2>$null | Out-Null
            Remove-Item -LiteralPath $bodyFile -ErrorAction SilentlyContinue
        }

        $epicRef = Get-EpicMilestoneTitle -EpicId $row['Epic'] -ProjectPath $ProjectPath -Board $Board
        if ($epicRef) {
            & gh issue edit $issueNumber --repo $Config.Repo --milestone $epicRef.Title 2>$null | Out-Null
            if ($row.ContainsKey('GitHub Milestone')) { $row['GitHub Milestone'] = $epicRef.Number; $changed = $true }
        }

        $itemId = Get-BoardItemId -Config $Config -Board $Board -IssueUrl $issueUrl -IssueNumber $issueNumber
        if ($itemId) {
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Status' -Value $boardStatus -ValueType 'SingleSelect'
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Estimate' -Value $row['Estimate'] -ValueType 'Number'
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Size' -Value $row['Size'] -ValueType 'SingleSelect'
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Iteration' -Value $row['Iteration'] -ValueType 'Iteration'
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Start date' -Value $row['Start'] -ValueType 'Date'
            Set-BoardFieldValue -Board $Board -Config $Config -ItemId $itemId -FieldName 'Target date' -Value $row['Ziel'] -ValueType 'Date'
        }

        if ($changed) {
            $newCells = $columns | ForEach-Object { $row[$_] }
            $lines[$i] = '| ' + ($newCells -join ' | ') + ' |'
        }
        Write-SyncInfo "$id → Issue #$issueNumber, Board-Status: $boardStatus"
    }

    if ($changed) {
        Set-Content -LiteralPath $FilePath -Value $lines
    }
}

# ── Hauptablauf ──────────────────────────────────────────────────────────

$configPath = Join-Path $ProjectPath '.toolchain.yml'
$config = Get-ToolchainConfig $configPath

if (-not $config -or -not $config.Enabled) {
    Write-SyncInfo "github.enabled ist false oder .toolchain.yml fehlt — Sync übersprungen."
    exit 0
}
if (-not $config.Repo) {
    Write-SyncWarn "github.repo nicht gesetzt — Sync übersprungen."
    exit 0
}
if (-not (Test-GhReady $config)) { exit 0 }

$board = Get-BoardContext $config

$phasePath = Join-Path $ProjectPath '.phase'
$currentPhase = 'INIT'
$currentSprint = $null
if (Test-Path -LiteralPath $phasePath) {
    $phaseText = Get-Content -LiteralPath $phasePath -Raw
    $m = [regex]::Match($phaseText, '(?m)^current-phase:\s*(\S+)')
    if ($m.Success) { $currentPhase = $m.Groups[1].Value }
    $ms = [regex]::Match($phaseText, '(?m)^sprint:\s*(\S+)')
    if ($ms.Success) { $currentSprint = $ms.Groups[1].Value }
}

# Epics zuerst — Milestones müssen existieren, bevor Stories/Bugs/Schulden darauf verweisen.
if ($Mode -eq 'push') {
    $epicFiles = Get-ChildItem -Path (Join-Path $ProjectPath 'requirements/EPIC-*.md') -ErrorAction SilentlyContinue
    foreach ($epicFile in $epicFiles) {
        Sync-EpicMilestone -FilePath $epicFile.FullName -Config $config -Board $board
    }
}

$targets = @(
    @{ Glob = 'requirements/US-*.md'; Type = 'US' },
    @{ Glob = 'testing/BUG-*.md'; Type = 'BUG' },
    @{ Glob = 'retros/IMPD-*.md'; Type = 'IMPD' }
)

foreach ($target in $targets) {
    $files = Get-ChildItem -Path (Join-Path $ProjectPath $target.Glob) -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Sync-Artifact -FilePath $file.FullName -ArtifactType $target.Type -Config $config -Board $board -CurrentPhase $currentPhase -CurrentSprint $currentSprint -Mode $Mode -ProjectPath $ProjectPath
    }
}

# DEBT-REGISTRY: eigene Tabellen-Logik statt Frontmatter-pro-Datei — siehe Protokoll.
$debtFiles = Get-ChildItem -Path (Join-Path $ProjectPath 'retros/DEBT-REGISTRY*.md') -ErrorAction SilentlyContinue
foreach ($debtFile in $debtFiles) {
    Sync-DebtRegistry -FilePath $debtFile.FullName -Config $config -Board $board -Mode $Mode -ProjectPath $ProjectPath
}

Write-SyncInfo "Sync-Modus '$Mode' abgeschlossen."
exit 0
