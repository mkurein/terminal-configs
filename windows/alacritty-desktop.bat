@echo off
REM ============================================================================
REM  alacritty-desktop.bat - Запуск Alacritty из текущей папки
REM ============================================================================
REM 
REM ИСПОЛЬЗОВАНИЕ:
REM   Скопируйте этот файл на рабочий стол или в любую папку проекта
REM   Двойной клик на файл откроет Alacritty в WSL в этой папке
REM 
REM ============================================================================

setlocal

set CONFIG_DIR=%USERPROFILE%\.config\alacritty
set CONFIG_FILE=%CONFIG_DIR%\alacritty.toml
set SOURCE_CONFIG=%~dp0alacritty\alacritty.toml

REM Создать директорию для конфигурации, если её нет
if not exist "%CONFIG_DIR%" (
    echo Создание директории: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

REM Скопировать конфигурацию, если её нет
if not exist "%CONFIG_FILE%" (
    if exist "%SOURCE_CONFIG%" (
        echo Копирование конфигурации Alacritty...
        copy "%SOURCE_CONFIG%" "%CONFIG_FILE%" >nul
        echo Конфигурация скопирована успешно!
        echo.
    )
)

REM Получить папку, где находится этот bat-файл
set "BATDIR=%~dp0"
REM Убрать завершающий слэш
set "BATDIR=%BATDIR:~0,-1%"

REM Конвертировать путь к папке bat-файла в WSL формат
for /f "delims=" %%i in ('wsl wslpath -u "%BATDIR%"') do set "WSLPATH=%%i"

REM Попробовать найти Alacritty через where (поиск в PATH)
where alacritty.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start "" alacritty.exe -e wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

REM Попробовать стандартные пути установки
if exist "C:\Program Files\Alacritty\alacritty.exe" (
    start "" "C:\Program Files\Alacritty\alacritty.exe" -e wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

if exist "%LOCALAPPDATA%\Programs\Alacritty\alacritty.exe" (
    start "" "%LOCALAPPDATA%\Programs\Alacritty\alacritty.exe" -e wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

if exist "%USERPROFILE%\.local\bin\alacritty.exe" (
    start "" "%USERPROFILE%\.local\bin\alacritty.exe" -e wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

REM Alacritty не найден
echo [ERROR] Alacritty не найден!
echo.
echo Установите Alacritty одним из способов:
echo   scoop install alacritty
echo   choco install alacritty
echo   winget install Alacritty.Alacritty
echo.
echo Или скачайте с: https://github.com/alacritty/alacritty/releases
echo.
pause
exit /b 1

:end
endlocal

