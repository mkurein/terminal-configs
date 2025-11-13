@echo off
REM Запуск Alacritty с WSL Debian + Zellij
REM Использует конфигурацию alacritty-debian.toml

set CONFIG_DIR=%USERPROFILE%\.config\alacritty
set CONFIG_FILE=%CONFIG_DIR%\alacritty-debian.toml

if not exist "%CONFIG_FILE%" (
    echo [ERROR] Конфигурационный файл не найден: %CONFIG_FILE%
    echo.
    echo Убедитесь, что вы скопировали alacritty-debian.toml в директорию:
    echo %CONFIG_DIR%\
    echo.
    pause
    exit /b 1
)

echo Запуск Alacritty с WSL Debian...
start "" alacritty --config-file "%CONFIG_FILE%"

