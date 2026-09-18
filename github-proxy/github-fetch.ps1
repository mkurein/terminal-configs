$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

Assert-GitHubWorkTree
Clear-GitHubProxyEnv

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green

# Profile wrapper can splat a lone $null; treat that as "no args".
$fetchArgs = @($args | Where-Object { $null -ne $_ -and "$_".Trim() -ne "" })

if ($fetchArgs.Count -eq 0) {
    Write-Host "Running: git fetch for each remote (skip missing/unreachable)" -ForegroundColor Cyan
    $nativePref = $PSNativeCommandUseErrorActionPreference
    $errPref = $ErrorActionPreference
    $PSNativeCommandUseErrorActionPreference = $false
    $ErrorActionPreference = "Continue"
    $skipped = $false
    git remote | ForEach-Object {
        $remote = $_.Trim()
        if (-not $remote) { return }
        Write-Host "Fetching $remote"
        git -c http.proxy= -c https.proxy= fetch $remote
        if ($LASTEXITCODE -ne 0) {
            Write-Host "warning: skip remote '$remote' (not found or unreachable)" -ForegroundColor Yellow
            $skipped = $true
        }
    }
    $ErrorActionPreference = $errPref
    $PSNativeCommandUseErrorActionPreference = $nativePref
    if ($skipped) {
        Write-Host "Fetch finished; at least one remote was skipped." -ForegroundColor Yellow
    }
} else {
    Write-Host "Running: git -c http.proxy= -c https.proxy= fetch $fetchArgs" -ForegroundColor Cyan
    git -c http.proxy= -c https.proxy= fetch @fetchArgs
}
