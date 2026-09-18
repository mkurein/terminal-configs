$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green

$msgParts = @($args | Where-Object { $null -ne $_ -and "$_".Trim() -ne "" })
$msg = ($msgParts -join " ").Trim()
if (-not $msg) {
    $msg = (Read-Host "Commit message").Trim()
}
if (-not $msg) {
    Write-Host "Commit message cannot be empty." -ForegroundColor Yellow
    exit 1
}

$errPref = $ErrorActionPreference
$ErrorActionPreference = "Continue"
git diff --cached --quiet
$stagedEmpty = ($LASTEXITCODE -eq 0)
$ErrorActionPreference = $errPref
if ($stagedEmpty) {
    Write-Host "Nothing staged. git add first, then github-commit." -ForegroundColor Yellow
    exit 1
}

Write-Host "Running: git commit -m ..." -ForegroundColor Cyan
git commit -m $msg
