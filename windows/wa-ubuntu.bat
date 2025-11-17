@echo off
REM Запуск Alacritty с WSL Ubuntu + Zellij
REM Использует конфигурацию alacritty-ubuntu.toml

set CONFIG_DIR=%USERPROFILE%\.config\alacritty
set CONFIG_FILE=%CONFIG_DIR%\alacritty-ubuntu.toml
set SOURCE_CONFIG=%~dp0alacritty\alacritty-ubuntu.toml

REM Создать директорию, если её нет
if not exist "%CONFIG_DIR%" (
    echo Создание директории: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

REM Скопировать конфигурацию, если её нет
if not exist "%CONFIG_FILE%" (
    if exist "%SOURCE_CONFIG%" (
        echo Копирование конфигурации из %SOURCE_CONFIG%
        copy "%SOURCE_CONFIG%" "%CONFIG_FILE%" >nul
        echo Конфигурация скопирована успешно!
        echo.
    ) else (
        echo [ERROR] Исходный файл конфигурации не найден: %SOURCE_CONFIG%
        echo.
        echo Убедитесь, что файл находится в:
        echo %~dp0alacritty\alacritty-ubuntu.toml
        echo.
        pause
        exit /b 1
    )
)

echo Запуск Alacritty с WSL Ubuntu...
start "" alacritty --config-file "%CONFIG_FILE%"

