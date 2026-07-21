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

# CHECK 2: File header present (code files) - warning only
$CodeExtensions = @('ts', 'tsx', 'js', 'jsx', 'py', 'go', 'java', 'cs', 'rs', 'rb', 'php')
$MissingHeaders = @()

foreach ($file in $StagedFiles) {
    $ext = ($file -split '\.')[-1]
    if ($CodeExtensions -contains $ext) {
        $firstLine = (git show ":$file" 2>$null) -split "`n" | Select-Object -First 1
        if ($firstLine -notmatch '^(//|#|/\*)') {
            $MissingHeaders += $file
        }
    }
}

if ($MissingHeaders.Count -gt 0) {
    Write-Output "  Missing file headers in:"
    foreach ($f in $MissingHeaders) { Write-Output "     - $f" }
    Write-Output "  Reminder: every code file should start with a header comment block."
}

# CHECK 3: No secrets/credentials - blocking
$SecretPatterns = @(
    "password\s*=\s*['""][^'""]{4,}",
    "secret\s*=\s*['""][^'""]{8,}",
    "api[_-]?key\s*=\s*['""][^'""]{8,}",
    "private[_-]?key\s*=\s*['""][^'""]{8,}",
    "BEGIN (RSA|EC|DSA|OPENSSH) PRIVATE KEY",
    "ghp_[A-Za-z0-9]{36}",
    "sk-[A-Za-z0-9]{40,}"
)

foreach ($file in $StagedFiles) {
    $content = git show ":$file" 2>$null
    if (-not $content) { continue }
    foreach ($pattern in $SecretPatterns) {
        if ($content -match $pattern) {
            Write-Output "  Possible secret in: $file (pattern: $pattern)"
            Write-Output "  Commit aborted. Secrets belong in environment variables, not code."
            exit 1
        }
    }
}

# CHECK 4: TODO marker format - warning only
$Roles = 'PM|BA|AR|UX|FE|BE|QA|RV'
$BadTodos = @()

foreach ($file in $StagedFiles) {
    $ext = ($file -split '\.')[-1]
    if ($CodeExtensions -contains $ext) {
        $content = git show ":$file" 2>$null
        if ($content -and ($content -match 'TODO') -and ($content -notmatch "TODO\(($Roles)\):")) {
            $BadTodos += $file
        }
    }
}

if ($BadTodos.Count -gt 0) {
    Write-Output "  Non-standard TODO markers in:"
    foreach ($f in $BadTodos) { Write-Output "     - $f" }
    Write-Output "  Standard: // TODO(ROLE): Description - YYYY-MM-DD"
}

Write-Output "pre-commit complete."
exit 0
