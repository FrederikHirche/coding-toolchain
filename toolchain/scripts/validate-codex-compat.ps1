<#
.SYNOPSIS
Prüft die additive Codex-Kompatibilitätsschicht der Claude-first Toolchain.

.DESCRIPTION
Validiert Dateien und Querverweise, ohne Repository-Inhalte zu verändern.
#>

$ErrorActionPreference = 'Stop'

$repositoryRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..\..')).Path
$failures = [System.Collections.Generic.List[string]]::new()
$checks = 0

function Test-RequiredPath {
    param(
        [Parameter(Mandatory = $true)]
        [string] $RelativePath
    )

    $script:checks++
    $absolutePath = Join-Path $repositoryRoot $RelativePath
    if (-not (Test-Path -LiteralPath $absolutePath)) {
        $script:failures.Add("Fehlt: $RelativePath")
    }
}

$requiredPaths = @(
    'CLAUDE.md',
    'AGENTS.md',
    '.codex\config.toml',
    '.agents\skills\coding-toolchain\SKILL.md',
    '.agents\skills\coding-toolchain\agents\openai.yaml',
    'projects\_template\AGENTS.md',
    'toolchain\agents\_base-agent.md',
    'toolchain\protocols\gate-protocol.md',
    'toolchain\protocols\handoff-protocol.md',
    'toolchain\protocols\artifact-lifecycle.md'
)

foreach ($requiredPath in $requiredPaths) {
    Test-RequiredPath -RelativePath $requiredPath
}

$expectedCommands = @(
    'architect', 'ba', 'coach', 'health-check', 'hotfix', 'impediment', 'implement',
    'kickoff', 'manual', 'refine', 'retro', 'review', 'spike', 'sprint', 'status',
    'test-plan', 'test-run', 'ux'
)

foreach ($command in $expectedCommands) {
    Test-RequiredPath -RelativePath ".claude\commands\$command.md"
}

$agentMappings = [ordered]@{
    'orchestrator' = 'orchestrator.md'
    'pm' = 'pm-agent.md'
    'ba' = 'ba-agent.md'
    'architect' = 'architect-agent.md'
    'ux' = 'ux-agent.md'
    'frontend' = 'frontend-agent.md'
    'backend' = 'backend-agent.md'
    'qa' = 'qa-agent.md'
    'reviewer' = 'reviewer-agent.md'
    'manual-writer' = 'manual-writer-agent.md'
    'agile-coach' = 'agile-coach-agent.md'
}

foreach ($adapterName in $agentMappings.Keys) {
    $adapterPath = ".codex\agents\$adapterName.toml"
    $canonicalPath = "toolchain\agents\$($agentMappings[$adapterName])"
    Test-RequiredPath -RelativePath $adapterPath
    Test-RequiredPath -RelativePath $canonicalPath

    $adapterAbsolutePath = Join-Path $repositoryRoot $adapterPath
    if (Test-Path -LiteralPath $adapterAbsolutePath) {
        $script:checks++
        $adapterContent = Get-Content -LiteralPath $adapterAbsolutePath -Raw
        if ($adapterContent -notmatch [regex]::Escape($agentMappings[$adapterName])) {
            $script:failures.Add("$adapterPath referenziert $canonicalPath nicht.")
        }
        if ($adapterContent -notmatch 'CLAUDE\.md') {
            $script:failures.Add("$adapterPath erklärt CLAUDE.md nicht zur Quelle.")
        }
    }
}

$configPath = Join-Path $repositoryRoot '.codex\config.toml'
if (Test-Path -LiteralPath $configPath) {
    $configContent = Get-Content -LiteralPath $configPath -Raw
    foreach ($adapterName in $agentMappings.Keys) {
        $script:checks++
        $configKey = $adapterName.Replace('-', '_')
        if ($configContent -notmatch "\[agents\.$([regex]::Escape($configKey))\]") {
            $script:failures.Add(".codex\config.toml registriert $adapterName nicht.")
        }
    }
}

$agentsPath = Join-Path $repositoryRoot 'AGENTS.md'
if (Test-Path -LiteralPath $agentsPath) {
    $script:checks++
    $agentsContent = Get-Content -LiteralPath $agentsPath -Raw
    if ($agentsContent -notmatch 'CLAUDE\.md.+Vorrang') {
        $script:failures.Add('AGENTS.md erklärt den Vorrang von CLAUDE.md nicht eindeutig.')
    }
}

$skillPath = Join-Path $repositoryRoot '.agents\skills\coding-toolchain\SKILL.md'
if (Test-Path -LiteralPath $skillPath) {
    $script:checks++
    $skillContent = Get-Content -LiteralPath $skillPath -Raw
    if ($skillContent -notmatch '(?m)^name:\s*coding-toolchain\s*$') {
        $script:failures.Add('Der Skill besitzt keinen gültigen Namen.')
    }
    if ($skillContent -match '\[TODO') {
        $script:failures.Add('Der Skill enthält noch TODO-Platzhalter.')
    }
}

if ($failures.Count -gt 0) {
    Write-Host "Codex-Kompatibilitätsprüfung: FEHLGESCHLAGEN ($checks Prüfungen)"
    foreach ($failure in $failures) {
        Write-Host "  - $failure"
    }
    exit 1
}

Write-Host "Codex-Kompatibilitätsprüfung: BESTANDEN ($checks Prüfungen)"
exit 0
