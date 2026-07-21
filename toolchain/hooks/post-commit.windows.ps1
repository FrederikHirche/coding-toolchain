#!C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe
# post-commit.windows.ps1 — AI Development Tool Chain
# PowerShell-native post-commit hook, installed (as the extension-less file `post-commit`)
# by setup-hooks.ps1. See pre-commit.windows.ps1's header comment for why this exists and
# why it targets Windows PowerShell 5.1 specifically, not `pwsh`. Functionally identical
# to the bash `post-commit` hook.

$RepoRoot = (git rev-parse --show-toplevel).Trim()

Write-Output "Tool Chain post-commit..."

$hasParent = git rev-parse --verify -q "HEAD~1" 2>$null
if (-not $hasParent) {
    Write-Output "post-commit complete (initial commit, no previous commit to diff against)."
    exit 0
}

$changedFiles = git diff HEAD~1 --name-only
$changedDirs = $changedFiles | ForEach-Object { Split-Path $_ -Parent } | Where-Object { $_ } | Sort-Object -Unique

foreach ($dir in $changedDirs) {
    $indexPath = Join-Path $RepoRoot "$dir/INDEX.md"
    $dirFullPath = Join-Path $RepoRoot $dir
    if ((Test-Path $dirFullPath) -and (Test-Path $indexPath)) {
        $dirChanged = $changedFiles | Where-Object { $_ -like "$dir/*" }
        $indexChanged = $changedFiles | Where-Object { $_ -eq "$dir/INDEX.md" }
        if ($dirChanged -and -not $indexChanged) {
            Write-Output "  INDEX.md in '$dir' was not updated."
            Write-Output "     Remember to record new/changed files in INDEX.md."
        }
    }
}

Write-Output "post-commit complete."
exit 0
