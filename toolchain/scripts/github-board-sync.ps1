<#
.SYNOPSIS
Synchronisiert Tool-Chain-Artefakte (US/BUG/DEBT/IMPD) mit einem GitHub Project (v2) Board.

.DESCRIPTION
Implementiert toolchain/protocols/github-board-sync.md. Best-effort, nie blockierend:
fehlt `gh`, Auth oder Board-Konfiguration, wird der Sync ohne Fehlercode übersprungen.
Nutzt ausschließlich die `gh`-CLI — kein eigener GraphQL-Client.

.PARAMETER ProjectPath
Pfad zu projects/<name> (enthält .toolchain.yml, .phase, INDEX.md).

.PARAMETER Mode
'push'      — Tool Chain → GitHub (Issues anlegen/aktualisieren, Frontmatter-ID zurückschreiben)
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
        $m = [regex]::Match($text, "(?m)^\s{2}$Key:\s*(.+?)\s*(#.*)?$")
        if ($m.Success) { return $m.Groups[1].Value.Trim() }
        return $null
    }

    $enabledRaw = Get-Scalar 'enabled'
    [PSCustomObject]@{
        Enabled       = ($enabledRaw -eq 'true')
        Repo          = (Get-Scalar 'repo') -replace '^~$', $null
        ProjectNumber = (Get-Scalar 'project-number') -replace '^~$', $null
        AuthMode      = (Get-Scalar 'auth-mode') -replace '^~$', 'gh-cli'
        AuthEnvVar    = (Get-Scalar 'auth-env-var') -replace '^~$', $null
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
    $status = & gh auth status --hostname github.com 2>&1
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

function Get-BoardStatus([string] $ArtifactType, [string] $ArtifactStatus, [string] $CurrentPhase) {
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
            # US-NNNNNN: kein eigener Fortschrittsstatus — abgeleitet aus Projektphase.
            switch -Regex ($CurrentPhase) {
                'REVIEW|DOCUMENTATION|DONE|RELEASED' { return 'Done' }
                'IMPLEMENTATION|TESTING' { return 'In Progress' }
                default { return 'Backlog' }
            }
        }
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
    [PSCustomObject]@{ Fields = $fields; RawHeaderMatch = $m; FullText = $text }
}

function Set-FrontmatterField([string] $FilePath, [string] $Key, [string] $Value) {
    $text = Get-Content -LiteralPath $FilePath -Raw
    $pattern = "(?m)^$Key:\s*.*$"
    if ($text -match $pattern) {
        $newText = $text -replace $pattern, "$Key`: $Value"
    } else {
        $newText = $text -replace "(?s)^(---\r?\n.*?)\r?\n---", "`$1`n$Key`: $Value`n---"
    }
    Set-Content -LiteralPath $FilePath -Value $newText -NoNewline
}

# ── Board-Feld-Auflösung ─────────────────────────────────────────────────
# gh project item-edit verlangt GraphQL-Node-IDs für --id/--field-id/--single-select-option-id,
# keine Klartext-Namen und keine Issue-Nummer. Diese IDs werden einmal pro Lauf aufgelöst
# und über die Sync-Funktionen hinweg zwischengespeichert (Board.ProjectId/StatusField/ItemsByIssue).

function Get-BoardContext([PSCustomObject] $Config) {
    $ctx = [PSCustomObject]@{
        Owner        = ($Config.Repo -split '/')[0]
        ProjectId    = $null
        StatusField  = $null
        ItemsByIssue = @{}
    }
    if (-not $Config.ProjectNumber) { return $ctx }

    $projView = & gh project view $Config.ProjectNumber --owner $ctx.Owner --format json 2>$null
    if ($LASTEXITCODE -eq 0 -and $projView) {
        $ctx.ProjectId = ($projView | ConvertFrom-Json).id
    }

    $fieldList = & gh project field-list $Config.ProjectNumber --owner $ctx.Owner --format json 2>$null
    if ($LASTEXITCODE -eq 0 -and $fieldList) {
        $fields = ($fieldList | ConvertFrom-Json).fields
        $ctx.StatusField = $fields | Where-Object { $_.name -eq 'Status' } | Select-Object -First 1
    }
    if (-not $ctx.StatusField) {
        Write-SyncWarn "Kein Status-Feld im Board gefunden — Status-Updates werden für diesen Lauf übersprungen."
    }

    $itemList = & gh project item-list $Config.ProjectNumber --owner $ctx.Owner --format json --limit 500 2>$null
    if ($LASTEXITCODE -eq 0 -and $itemList) {
        foreach ($item in ($itemList | ConvertFrom-Json).items) {
            if ($item.content -and $item.content.number) {
                $ctx.ItemsByIssue["$($item.content.number)"] = $item.id
            }
        }
    }
    return $ctx
}

function Resolve-StatusOptionId([PSCustomObject] $StatusField, [string] $BoardStatus) {
    if (-not $StatusField) { return $null }
    $opt = $StatusField.options | Where-Object { $_.name -eq $BoardStatus } | Select-Object -First 1
    if (-not $opt) { $opt = $StatusField.options | Where-Object { $_.name -like "*$BoardStatus*" } | Select-Object -First 1 }
    if ($opt) { return $opt.id }
    return $null
}

function Set-BoardItemStatus {
    param(
        [PSCustomObject] $Config,
        [PSCustomObject] $Board,
        [string] $IssueUrl,
        [string] $IssueNumber,
        [string] $BoardStatus
    )
    if (-not $Config.ProjectNumber -or -not $Board.ProjectId -or -not $Board.StatusField) { return }

    $itemId = $null
    if ($IssueUrl) {
        $added = & gh project item-add $Config.ProjectNumber --owner $Board.Owner --url $IssueUrl --format json 2>$null
        if ($LASTEXITCODE -eq 0 -and $added) {
            $itemId = ($added | ConvertFrom-Json).id
            $Board.ItemsByIssue[$IssueNumber] = $itemId
        }
    } elseif ($Board.ItemsByIssue.ContainsKey($IssueNumber)) {
        $itemId = $Board.ItemsByIssue[$IssueNumber]
    }
    if (-not $itemId) { return }

    $optionId = Resolve-StatusOptionId $Board.StatusField $BoardStatus
    if (-not $optionId) {
        Write-SyncWarn "Keine passende Status-Option für '$BoardStatus' im Board gefunden — Update übersprungen."
        return
    }
    & gh project item-edit --id $itemId --field-id $Board.StatusField.id --project-id $Board.ProjectId --single-select-option-id $optionId 2>$null | Out-Null
}

function Sync-Artifact {
    param(
        [string] $FilePath,
        [string] $ArtifactType,
        [PSCustomObject] $Config,
        [PSCustomObject] $Board,
        [string] $CurrentPhase,
        [string] $Mode
    )

    $fm = Get-Frontmatter $FilePath
    if (-not $fm) { return }

    $issueNumber = $fm.Fields['github-issue']
    $title = $fm.Fields['title']
    $artifactStatus = $fm.Fields['status']
    $boardStatus = Get-BoardStatus -ArtifactType $ArtifactType -ArtifactStatus $artifactStatus -CurrentPhase $CurrentPhase

    if ($ArtifactType -eq 'IMPD' -and $artifactStatus -eq 'RESOLVED' -and (-not $issueNumber -or $issueNumber -eq '—')) {
        # Sofort gelöste Impediments erzeugen laut Protokoll kein Issue.
        return
    }

    if ($Mode -eq 'reconcile') {
        if (-not $issueNumber -or $issueNumber -eq '—') { return }
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
    if (-not $issueNumber -or $issueNumber -eq '—') {
        $created = & gh issue create --repo $Config.Repo --title "$ArtifactType`: $title" --body "Synchronisiert aus $FilePath" 2>&1
        if ($LASTEXITCODE -ne 0) {
            Write-SyncWarn "Issue-Erstellung fehlgeschlagen für $FilePath`: $created"
            return
        }
        $issueUrl = ($created | Select-String -Pattern 'https://\S+').Matches[0].Value
        $issueNumber = ($issueUrl -split '/')[-1]
        Set-FrontmatterField -FilePath $FilePath -Key 'github-issue' -Value $issueNumber
        Write-SyncInfo "Issue #$issueNumber angelegt für $FilePath"
    }

    Set-BoardItemStatus -Config $Config -Board $Board -IssueUrl $issueUrl -IssueNumber $issueNumber -BoardStatus $boardStatus
    Write-SyncInfo "$FilePath → Issue #$issueNumber, Board-Status: $boardStatus"
}

function Sync-DebtRegistry {
    param(
        [string] $FilePath,
        [PSCustomObject] $Config,
        [PSCustomObject] $Board,
        [string] $Mode
    )

    $lines = Get-Content -LiteralPath $FilePath
    $rowPattern = '^\|\s*(DEBT-\d+)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*(.*?)\s*\|\s*$'
    $changed = $false

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $m = [regex]::Match($lines[$i], $rowPattern)
        if (-not $m.Success) { continue }

        $id = $m.Groups[1].Value
        $titleText = $m.Groups[2].Value
        $status = $m.Groups[7].Value
        $issueNumber = $m.Groups[8].Value
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
        if (-not $issueNumber -or $issueNumber -eq '—') {
            $created = & gh issue create --repo $Config.Repo --title "DEBT: $titleText" --body "Synchronisiert aus $FilePath ($id)" 2>&1
            if ($LASTEXITCODE -ne 0) {
                Write-SyncWarn "Issue-Erstellung fehlgeschlagen für $id`: $created"
                continue
            }
            $issueUrl = ($created | Select-String -Pattern 'https://\S+').Matches[0].Value
            $issueNumber = ($issueUrl -split '/')[-1]
            $lines[$i] = $lines[$i] -replace '\|\s*—?\s*\|\s*$', "| $issueNumber |"
            $changed = $true
            Write-SyncInfo "Issue #$issueNumber angelegt für $id"
        }

        Set-BoardItemStatus -Config $Config -Board $Board -IssueUrl $issueUrl -IssueNumber $issueNumber -BoardStatus $boardStatus
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
if (Test-Path -LiteralPath $phasePath) {
    $phaseText = Get-Content -LiteralPath $phasePath -Raw
    $m = [regex]::Match($phaseText, '(?m)^current-phase:\s*(\S+)')
    if ($m.Success) { $currentPhase = $m.Groups[1].Value }
}

$targets = @(
    @{ Glob = 'requirements/US-*.md'; Type = 'US' },
    @{ Glob = 'testing/BUG-*.md'; Type = 'BUG' },
    @{ Glob = 'retros/IMPD-*.md'; Type = 'IMPD' }
)

foreach ($target in $targets) {
    $files = Get-ChildItem -Path (Join-Path $ProjectPath $target.Glob) -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        Sync-Artifact -FilePath $file.FullName -ArtifactType $target.Type -Config $config -Board $board -CurrentPhase $currentPhase -Mode $Mode
    }
}

# DEBT-REGISTRY: eigene Tabellen-Logik statt Frontmatter-pro-Datei — siehe Protokoll.
$debtFiles = Get-ChildItem -Path (Join-Path $ProjectPath 'retros/DEBT-REGISTRY*.md') -ErrorAction SilentlyContinue
foreach ($debtFile in $debtFiles) {
    Sync-DebtRegistry -FilePath $debtFile.FullName -Config $config -Board $board -Mode $Mode
}

Write-SyncInfo "Sync-Modus '$Mode' abgeschlossen."
exit 0
