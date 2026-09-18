$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green
Write-Host "Running: git -c http.proxy= -c https.proxy= fetch" -ForegroundColor Cyan

git -c http.proxy= -c https.proxy= fetch @args
