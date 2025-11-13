# 🚀 PowerShell Profile Installer
# Установка PowerShell алиасов

Write-Host "🚀 Установка PowerShell алиасов..." -ForegroundColor Green
Write-Host ""

# Проверка пути к профилю
$profilePath = $PROFILE

Write-Host "📁 Путь к профилю: $profilePath" -ForegroundColor Cyan

# Создание директории профиля, если не существует
$profileDir = Split-Path -Parent $profilePath
if (!(Test-Path -Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
    Write-Host "✓ Создана директория: $profileDir" -ForegroundColor Green
}

# Создание резервной копии, если профиль существует
if (Test-Path -Path $profilePath) {
    $backupPath = "$profilePath.backup.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
    Copy-Item -Path $profilePath -Destination $backupPath
    Write-Host "✓ Создана резервная копия: $backupPath" -ForegroundColor Yellow
}

# Копирование профиля
$scriptPath = Join-Path $PSScriptRoot "Microsoft.PowerShell_profile.ps1"
if (Test-Path -Path $scriptPath) {
    Copy-Item -Path $scriptPath -Destination $profilePath -Force
    Write-Host "✓ Профиль установлен: $profilePath" -ForegroundColor Green
} else {
    Write-Host "✗ Файл профиля не найден: $scriptPath" -ForegroundColor Red
    exit 1
}

# Проверка политики выполнения
Write-Host ""
Write-Host "🔍 Проверка политики выполнения..." -ForegroundColor Cyan
$executionPolicy = Get-ExecutionPolicy -Scope CurrentUser
Write-Host "Текущая политика: $executionPolicy" -ForegroundColor Cyan

if ($executionPolicy -eq "Restricted") {
    Write-Host ""
    Write-Host "⚠ Внимание: Политика выполнения 'Restricted'!" -ForegroundColor Yellow
    Write-Host "Профиль не будет загружаться автоматически." -ForegroundColor Yellow
    Write-Host ""
    $change = Read-Host "Изменить политику на 'RemoteSigned'? (Y/N)"
    if ($change -eq "Y" -or $change -eq "y") {
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        Write-Host "✓ Политика изменена на 'RemoteSigned'" -ForegroundColor Green
    }
}

# Загрузка профиля
Write-Host ""
Write-Host "🔄 Загрузка профиля..." -ForegroundColor Cyan
try {
    . $profilePath
    Write-Host "✓ Профиль успешно загружен!" -ForegroundColor Green
} catch {
    Write-Host "✗ Ошибка при загрузке профиля: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "================================================================" -ForegroundColor Green
Write-Host "✓ Установка завершена!" -ForegroundColor Green
Write-Host "================================================================" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Следующие шаги:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Перезапустите PowerShell или выполните:" -ForegroundColor White
Write-Host "   . `$PROFILE" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Проверьте работу алиасов:" -ForegroundColor White
Write-Host "   gs              # git status" -ForegroundColor Yellow
Write-Host "   gq-help         # Справка по Git Quick" -ForegroundColor Yellow
Write-Host ""
Write-Host "3. Если команды не работают, проверьте:" -ForegroundColor White
Write-Host "   Get-ExecutionPolicy" -ForegroundColor Yellow
Write-Host "   Set-ExecutionPolicy RemoteSigned -Scope CurrentUser" -ForegroundColor Yellow
Write-Host ""
Write-Host "📖 Документация: windows\powershell\README.md" -ForegroundColor Cyan
Write-Host ""

