$ErrorActionPreference = "Stop"
. "$PSScriptRoot\_lib.ps1"

function Ensure-GhInstalled {
    if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
        Write-Host "gh не найден. Установите GitHub CLI: https://cli.github.com/" -ForegroundColor Red
        exit 1
    }
}

function Show-Menu {
    Write-Host ""
    Write-Host "=== GitHub CLI (gh) ===" -ForegroundColor Cyan
    Write-Host " 1) gh auth status"
    Write-Host " 2) gh auth login"
    Write-Host " 3) gh auth refresh (scope: workflow)"
    Write-Host " 4) gh auth refresh (scope: workflow + repo)"
    Write-Host " 5) gh repo view (открыть в браузере)"
    Write-Host " 6) gh pr list"
    Write-Host " 7) gh pr create"
    Write-Host " 8) gh run list (последние 5)"
    Write-Host " 9) gh run watch (последний run)"
    Write-Host " 0) выход"
    Write-Host ""
}

Assert-GitHubWorkTree
Clear-GitHubProxyEnv
Ensure-GhInstalled

Write-Host "Proxy variables cleared for this terminal session." -ForegroundColor Green

while ($true) {
    Show-Menu
    $choice = Read-Host "Выберите пункт"

    switch ($choice) {
        "1" { gh auth status }
        "2" { gh auth login }
        "3" { gh auth refresh -h github.com -s workflow }
        "4" { gh auth refresh -h github.com -s workflow -s repo }
        "5" { gh repo view --web }
        "6" { gh pr list }
        "7" {
            $title = Read-Host "Заголовок PR"
            if ([string]::IsNullOrWhiteSpace($title)) {
                Write-Host "Заголовок не может быть пустым." -ForegroundColor Yellow
                continue
            }
            $body = Read-Host "Описание PR (можно Enter для пустого)"
            if ([string]::IsNullOrWhiteSpace($body)) {
                gh pr create --title $title
            } else {
                gh pr create --title $title --body $body
            }
        }
        "8" { gh run list --limit 5 }
        "9" { gh run watch }
        "0" {
            Write-Host "Выход." -ForegroundColor Green
            break
        }
        default {
            Write-Host "Неизвестный пункт: $choice" -ForegroundColor Yellow
        }
    }
}
