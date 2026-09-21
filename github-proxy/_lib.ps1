# Shared helpers for github-proxy/*.ps1. Dotted from those scripts; do not run directly.
#
# «The term 'github-…' is not recognized» — команда не в этой сессии (не PATH).
#   . $PROFILE
# Tip без имени команды — профиль на диске старый:
#   cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE
# Напрямую из любого .git:
#   & C:\Project\terminal-configs\github-proxy\github-commit.ps1 "msg"
# macOS: source ~/.zshrc
#        source "$HOME/Project/terminal-configs/github-proxy/env.sh"

function Show-GitHubProxyLoadHint {
    param([string]$CommandName = "github-*")
    Write-Host ""
    Write-Host "Команда '$CommandName' не загружена в этой сессии. Это функция профиля, не PATH." -ForegroundColor Yellow
    Write-Host "Исправление (Windows):" -ForegroundColor Cyan
    Write-Host '  . $PROFILE' -ForegroundColor White
    Write-Host "Если Tip всё ещё без этой команды:" -ForegroundColor Cyan
    Write-Host "  cd C:\Project\terminal-configs\windows\powershell" -ForegroundColor White
    Write-Host "  .\install.ps1" -ForegroundColor White
    Write-Host '  . $PROFILE' -ForegroundColor White
    $here = $PSScriptRoot
    if (-not $here) { $here = "C:\Project\terminal-configs\github-proxy" }
    Write-Host "Напрямую (cwd уже git-репо):" -ForegroundColor Cyan
    Write-Host "  & `"$here\$CommandName.ps1`"" -ForegroundColor White
    Write-Host "macOS:" -ForegroundColor Cyan
    Write-Host "  source ~/.zshrc" -ForegroundColor White
    Write-Host '  source "$HOME/Project/terminal-configs/github-proxy/env.sh"' -ForegroundColor White
    Write-Host ""
}

function Clear-GitHubProxyEnv {
    Remove-Item Env:HTTP_PROXY, Env:HTTPS_PROXY, Env:ALL_PROXY, Env:NO_PROXY, Env:http_proxy, Env:https_proxy, Env:all_proxy, Env:no_proxy -ErrorAction SilentlyContinue
}

function Assert-GitHubWorkTree {
    git rev-parse --is-inside-work-tree 2>$null | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Not a git repository (cwd: $(Get-Location))" -ForegroundColor Red
        exit 1
    }
}

function Show-GitHubRepoStatus {
    $branch = (git --no-pager branch --show-current 2>$null | Out-String).Trim()
    if (-not $branch) { $branch = "(detached HEAD)" }
    Write-Host "Current branch: $branch" -ForegroundColor Cyan
    git --no-pager status -sb
}
