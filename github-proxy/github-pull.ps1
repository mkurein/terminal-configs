# «The term 'github-pull' is not recognized» — не PATH, старая сессия.
#   . $PROFILE
# Tip без github-pull: cd C:\Project\terminal-configs\windows\powershell; .\install.ps1; . $PROFILE
# Напрямую: & C:\Project\terminal-configs\github-proxy\github-pull.ps1
# macOS: source ~/.zshrc   или   source ~/Project/terminal-configs/github-proxy/env.sh
$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green
Write-Host "Running: git -c http.proxy= -c https.proxy= pull" -ForegroundColor Cyan

git -c http.proxy= -c https.proxy= pull @args
