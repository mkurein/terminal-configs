$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green

if ($args.Count -eq 0) {
    Write-Host "Running: git -c http.proxy= -c https.proxy= fetch --all" -ForegroundColor Cyan
    git -c http.proxy= -c https.proxy= fetch --all
} else {
    Write-Host "Running: git -c http.proxy= -c https.proxy= fetch $args" -ForegroundColor Cyan
    git -c http.proxy= -c https.proxy= fetch @args
}
