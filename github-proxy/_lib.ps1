# Shared helpers for github-proxy/*.ps1. Dotted from those scripts; do not run directly.

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
