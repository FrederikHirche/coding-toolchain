#requires -version 5.1
<#
.SYNOPSIS
  setup-hooks.ps1 — AI Development Tool Chain
  Installiert Git Hooks fuer das aktuelle Repository (native PowerShell-Variante von setup-hooks.sh).

.DESCRIPTION
  Was installiert wird:
    - pre-commit:  Lint, Header-Check, Secret-Scan, TODO-Format-Check
    - post-commit: INDEX.md-Erinnerung, Artefakt-Pflege-Hinweis

.PARAMETER ProjectRoot
  Pfad zum Projekt-Repository (Standard: aktuelles Verzeichnis)

.EXAMPLE
  pwsh toolchain/hooks/setup-hooks.ps1

.EXAMPLE
  pwsh toolchain/hooks/setup-hooks.ps1 -ProjectRoot C:\pfad\zum\projekt
#>

param(
    [string]$ProjectRoot = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────
# Konfiguration
# ─────────────────────────────────────
$ToolchainDir = Split-Path -Parent $PSScriptRoot
$GitHooksDir = Join-Path $ProjectRoot ".git\hooks"

# ─────────────────────────────────────
# Validierung
# ─────────────────────────────────────
if (-not (Test-Path (Join-Path $ProjectRoot ".git"))) {
    Write-Host "Fehler: $ProjectRoot ist kein Git-Repository." -ForegroundColor Red
    Write-Host "   Erst 'git init' ausfuehren." -ForegroundColor Red
    exit 1
}

Write-Host "Tool Chain Hooks installieren..." -ForegroundColor Cyan
Write-Host "   Toolchain: $ToolchainDir"
Write-Host "   Projekt:   $ProjectRoot"
Write-Host ""

# ─────────────────────────────────────
# Hooks installieren
# ─────────────────────────────────────
# Git fuehrt Hooks unter Windows ueber die Git-Bash-Shim aus; die Hook-Dateien
# bleiben deshalb unveraendert (Bash-Skripte ohne .sh-Endung), nur das
# Installationsscript selbst ist hier PowerShell-nativ.
$Hooks = @("pre-commit", "post-commit")

foreach ($Hook in $Hooks) {
    $Src = Join-Path $ToolchainDir "hooks\$Hook"
    $Dst = Join-Path $GitHooksDir $Hook

    if (-not (Test-Path $Src)) {
        Write-Host "  Warnung: Hook-Quelle nicht gefunden: $Src - uebersprungen." -ForegroundColor Yellow
        continue
    }

    if (Test-Path $Dst) {
        $Backup = "$Dst.backup-$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item $Dst $Backup
        Write-Host "  Bestehender $Hook gesichert: $Backup"
    }

    New-Item -ItemType Directory -Force -Path $GitHooksDir | Out-Null
    Copy-Item $Src $Dst -Force
    Write-Host "  $Hook installiert" -ForegroundColor Green
}

# ─────────────────────────────────────
# .toolchain-config erstellen (falls nicht vorhanden)
# ─────────────────────────────────────
$ConfigFile = Join-Path $ProjectRoot ".toolchain-config"

if (-not (Test-Path $ConfigFile)) {
    @"
# .toolchain-config — AI Development Tool Chain
# Projektspezifische Konfiguration fuer die Tool Chain Hooks.
# Diese Datei ins Repository einchecken.

# Lint-Befehl (wird im pre-commit ausgefuehrt)
# Beispiele:
#   npm run lint
#   ruff check .
#   golangci-lint run
lint=

# Test-Befehl (fuer /test-run)
# Beispiele:
#   npm test
#   pytest
#   go test ./...
test=

# Coverage-Befehl
coverage=
"@ | Set-Content -Path $ConfigFile -Encoding UTF8
    Write-Host "  .toolchain-config erstellt (bitte befuellen)" -ForegroundColor Green
}

Write-Host ""
Write-Host "Installation abgeschlossen!" -ForegroundColor Cyan
Write-Host ""
Write-Host "Naechste Schritte:"
Write-Host "  1. .toolchain-config befuellen (Lint- und Test-Befehle)"
Write-Host "  2. Tool Chain starten: /kickoff in Claude Code"
