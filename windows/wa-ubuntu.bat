@echo off
REM Запуск Alacritty с WSL Ubuntu + Zellij
REM Использует конфигурацию alacritty-ubuntu.toml

set CONFIG_DIR=%USERPROFILE%\.config\alacritty
set CONFIG_FILE=%CONFIG_DIR%\alacritty-ubuntu.toml

if not exist "%CONFIG_FILE%" (
    echo [ERROR] Конфигурационный файл не найден: %CONFIG_FILE%
    echo.
    echo Убедитесь, что вы скопировали alacritty-ubuntu.toml в директорию:
    echo %CONFIG_DIR%\
    echo.
    pause
    exit /b 1
)

echo Запуск Alacritty с WSL Ubuntu...
start "" alacritty --config-file "%CONFIG_FILE%"

