#!C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
# pre-commit.windows.ps1 — AI Development Tool Chain
# PowerShell-native pre-commit hook, installed (as the extension-less file `pre-commit`)
# by setup-hooks.ps1 for environments where a real bash is not available — e.g. MinGit
# installs (no bundled sh.exe/bash.exe) with only Windows' non-functional WSL `bash.exe`
# launcher stub on PATH. Functionally identical to the bash `pre-commit` hook (same 4
# checks); ported so it needs no bash/WSL at all.
#
# Uses Windows PowerShell 5.1 (`C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe`,
# the shebang interpreter above) instead of `pwsh` (PowerShell 7): when git invokes a hook
# via its shebang line, it does not forward any shebang arguments — it always calls
# `<interpreter> <hook-path>` with no flags. PowerShell 7's default argument binding
# requires a `.ps1` extension on that bare positional path and refuses to run it
# ("Processing -File '...' failed because the file does not have a '.ps1' extension.").
# Windows PowerShell 5.1's legacy argument binding accepts the extension-less path
# directly, so it — not pwsh — must be the interpreter for hook files installed as
# `pre-commit`/`post-commit` (no extension, required by git).

$ErrorActionPreference = "Stop"
$RepoRoot = (git rev-parse --show-toplevel).Trim()
$StagedFiles = git diff --cached --name-only --diff-filter=ACM

Write-Output "Tool Chain pre-commit checks..."

# CHECK 1: Lint (if a lint command is configured)
$ConfigFile = Join-Path $RepoRoot ".toolchain-config"
if (Test-Path $ConfigFile) {
    $lintLine = Get-Content $ConfigFile | Where-Object { $_ -match '^lint=' } | Select-Object -First 1
    if ($lintLine) {
        $lintCmd = $lintLine -replace '^lint=', ''
        if ($lintCmd.Trim().Length -gt 0) {
            Write-Output "  Lint: $lintCmd"
            Push-Location $RepoRoot
            try {
                Invoke-Expression $lintCmd
                if ($LASTEXITCODE -ne 0) {
                    Write-Output "  Lint failed. Commit aborted."
                    exit 1
                }
            } finally {
                Pop-Location
            }
        }
    }
}

# CHECKS 2-4: single pass over staged files, ONE `git show` subprocess per file
# (IMPD-000001: the original code called `git show ":$file"` separately in each of
# CHECK 2/3/4 — up to 3 subprocess spawns per file, ~165 for a 55-file commit. On this
# Windows environment that measurably turned an instant check into an 11+ minute
# near-idle-CPU stall. One fetch per file, reused by all three checks below, cuts
# subprocess count ~3x regardless of the exact root cause of the per-spawn cost.)
$CodeExtensions = @('ts', 'tsx', 'js', 'jsx', 'py', 'go', 'java', 'cs', 'rs', 'rb', 'php')
$SecretPatterns = @(
    "password\s*=\s*['""][^'""]{4,}",
    "secret\s*=\s*['""][^'""]{8,}",
    "api[_-]?key\s*=\s*['""][^'""]{8,}",
    "private[_-]?key\s*=\s*['""][^'""]{8,}",
    "BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY",
    "ghp_[A-Za-z0-9]{36}",
    "sk-[A-Za-z0-9]{40,}"
)
$Roles = 'PM|BA|AR|UX|FE|BE|QA|RV'
$MissingHeaders = @()
$BadTodos = @()

foreach ($file in $StagedFiles) {
    $ext = ($file -split '\.')[-1]
    $isCode = $CodeExtensions -contains $ext
    if (-not $isCode) {
        # Secret scan (CHECK 3) still applies to every file, code or not.
        $content = git show ":$file" 2>$null
        if (-not $content) { continue }
        foreach ($pattern in $SecretPatterns) {
            if ($content -match $pattern) {
                Write-Output "  Possible secret in: $file (pattern: $pattern)"
                Write-Output "  Commit aborted. Secrets belong in environment variables, not code."
                exit 1
            }
        }
        continue
    }

    $content = git show ":$file" 2>$null
    if (-not $content) { continue }

    # CHECK 2: file header present — warning only
    $firstLine = ($content -split "`n")[0]
    if ($firstLine -notmatch '^(//|#|/\*)') {
        $MissingHeaders += $file
    }

    # CHECK 3: no secrets/credentials — blocking
    foreach ($pattern in $SecretPatterns) {
        if ($content -match $pattern) {
            Write-Output "  Possible secret in: $file (pattern: $pattern)"
            Write-Output "  Commit aborted. Secrets belong in environment variables, not code."
            exit 1
        }
    }

    # CHECK 4: TODO marker format — warning only
    if (($content -match 'TODO') -and ($content -notmatch "TODO\(($Roles)\):")) {
        $BadTodos += $file
    }
}

if ($MissingHeaders.Count -gt 0) {
    Write-Output "  Missing file headers in:"
    foreach ($f in $MissingHeaders) { Write-Output "     - $f" }
    Write-Output "  Reminder: every code file should start with a header comment block."
}

if ($BadTodos.Count -gt 0) {
    Write-Output "  Non-standard TODO markers in:"
    foreach ($f in $BadTodos) { Write-Output "     - $f" }
    Write-Output "  Standard: // TODO(ROLE): Description - YYYY-MM-DD"
}

Write-Output "pre-commit complete."
exit 0
