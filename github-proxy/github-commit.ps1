# «The term 'github-commit' is not recognized» — не PATH, старая сессия.
#   . $PROFILE
# Tip без github-commit: cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE
# Напрямую: & C:\Project\terminal-configs\github-proxy\github-commit.ps1 "msg"
# macOS: source ~/.zshrc   или   source ~/Project/terminal-configs/github-proxy/env.sh
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green

$errPref = $ErrorActionPreference
$ErrorActionPreference = "Continue"
git diff --cached --quiet
$stagedEmpty = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $errPref
if ($stagedEmpty) {
    Write-Host "Nothing staged. git add first, then github-commit." -ForegroundColor Yellow
    exit 1
}

if ($args.Count -ge 1 -and ($args[0] -eq "-e" -or $args[0] -eq "--edit")) {
    Write-Host "Running: git commit  (editor)" -ForegroundColor Cyan
    git commit
    exit $LASTEXITCODE
}

$msg = ""
if ($args.Count -gt 0) {
    $msg = ($args -join " ").Trim()
} elseif ([Console]::IsInputRedirected) {
    $msg = [Console]::In.ReadToEnd()
} else {
    Write-Host ""
    Write-Host "Сообщение коммита. Проще всего:" -ForegroundColor Cyan
    Write-Host "  1) одна строка темы" -ForegroundColor White
    Write-Host "  2) на следующей строке только точка  ." -ForegroundColor White
    Write-Host "Пустая строка не нужна. Она только если после темы хотите абзац." -ForegroundColor DarkGray
    Write-Host "Отмена: Ctrl+C. Редактор: github-commit -e" -ForegroundColor DarkGray
    Write-Host "Или сразу: github-commit `"тема в кавычках`"" -ForegroundColor DarkGray
    Write-Host ""
    $lines = New-Object System.Collections.Generic.List[string]
    while ($true) {
        $hint = if ($lines.Count -eq 0) { "тема" } else { "ещё строка или ." }
        $line = Read-Host $hint
        if ($line -eq ".") { break }
        [void]$lines.Add($line)
    }
    $msg = [string]::Join("`n", $lines.ToArray())
}

$msg = $msg.Trim()
if (-not $msg) {
    Write-Host "Commit message cannot be empty." -ForegroundColor Yellow
    exit 1
}

$tmp = Join-Path ([System.IO.Path]::GetTempPath()) ("gh-commit-" + [guid]::NewGuid().ToString() + ".txt")
try {
    [System.IO.File]::WriteAllText($tmp, $msg)
    Write-Host "Running: git commit -F ..." -ForegroundColor Cyan
    git commit -F $tmp
} finally {
    if (Test-Path $tmp) { Remove-Item -Force $tmp }
}
