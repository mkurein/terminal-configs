@echo off
setlocal EnableDelayedExpansion
REM ============================================================================
REM  wa.bat - Быстрый запуск Alacritty в текущей папке Windows + WSL
REM ============================================================================
REM 
REM ОПИСАНИЕ:
REM   Открывает Alacritty в текущей папке проводника с автоматическим
REM   переходом в WSL и запуском zsh + Zellij c LazyVim layout-меню
REM 
REM УСТАНОВКА:
REM   1. Скопируйте этот файл в C:\Windows\System32\  (нужен админ)
REM   2. Убедитесь, что папка windows\alacritty\ находится рядом с bat-файлом
REM 
REM ============================================================================

set "CONFIG_DIR=%USERPROFILE%\.config\alacritty"
set "SOURCE_DIR=%~dp0alacritty"

if not exist "%CONFIG_DIR%" (
    echo Создание директории конфигураций: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

if exist "%SOURCE_DIR%" (
    for %%F in (alacritty.toml alacritty-ubuntu.toml alacritty-debian.toml) do (
        if exist "%SOURCE_DIR%\%%F" if not exist "%CONFIG_DIR%\%%F" (
            echo Копирование %%F в %CONFIG_DIR%...
            copy "%SOURCE_DIR%\%%F" "%CONFIG_DIR%\%%F" >nul
        )
    )
)

for /f "delims=" %%i in ('wsl wslpath -u "%cd%"') do set "WSLPATH=%%i"

set "ALACRITTY_EXE="
for /f "delims=" %%i in ('where alacritty.exe 2^>nul') do if not defined ALACRITTY_EXE set "ALACRITTY_EXE=%%i"

if not defined ALACRITTY_EXE if exist "C:\Program Files\Alacritty\alacritty.exe" set "ALACRITTY_EXE=C:\Program Files\Alacritty\alacritty.exe"
if not defined ALACRITTY_EXE if exist "%LOCALAPPDATA%\Programs\Alacritty\alacritty.exe" set "ALACRITTY_EXE=%LOCALAPPDATA%\Programs\Alacritty\alacritty.exe"
if not defined ALACRITTY_EXE if exist "%USERPROFILE%\.local\bin\alacritty.exe" set "ALACRITTY_EXE=%USERPROFILE%\.local\bin\alacritty.exe"

if not defined ALACRITTY_EXE (
    echo [ERROR] Alacritty не найден. Установите его через scoop/choco/winget.
    exit /b 1
)

start "" "%ALACRITTY_EXE%" -e wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && ~/start-zellij-choose.sh"

endlocal