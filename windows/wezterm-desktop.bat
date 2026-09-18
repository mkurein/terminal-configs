@echo off
REM ============================================================================
REM  wezterm-desktop.bat - Запуск WezTerm из текущей папки
REM ============================================================================
REM 
REM ИСПОЛЬЗОВАНИЕ:
REM   Скопируйте этот файл на рабочий стол для быстрого запуска WezTerm
REM   Двойной клик откроет WezTerm в домашней папке WSL (~)
REM   
REM   Для перехода в папку "Рабочий стол" в WezTerm выполните:
REM     cd "/mnt/c/Users/USERNAME/Desktop"
REM   
REM   Для запуска WezTerm в конкретной папке используйте команду "ww" 
REM   в адресной строке проводника (работает с любыми путями, включая кириллицу)
REM 
REM ============================================================================

setlocal

set CONFIG_DIR=%USERPROFILE%\.config\wezterm
set CONFIG_FILE=%CONFIG_DIR%\wezterm.lua
set SOURCE_CONFIG=%~dp0wezterm\wezterm.lua

REM Создать директорию для конфигурации, если её нет
if not exist "%CONFIG_DIR%" (
    echo Создание директории: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

REM Скопировать конфигурацию, если её нет
if not exist "%CONFIG_FILE%" (
    if exist "%SOURCE_CONFIG%" (
        echo Копирование конфигурации WezTerm...
        copy "%SOURCE_CONFIG%" "%CONFIG_FILE%" >nul
        echo Конфигурация скопирована успешно!
        echo.
    )
)

REM Попробовать найти WezTerm через where (поиск в PATH)
where wezterm-gui.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start "" wezterm-gui.exe
    goto :end
)

REM Попробовать стандартные пути установки
if exist "C:\Program Files\WezTerm\wezterm-gui.exe" (
    start "" "C:\Program Files\WezTerm\wezterm-gui.exe"
    goto :end
)

if exist "%USERPROFILE%\.local\bin\wezterm-gui.exe" (
    start "" "%USERPROFILE%\.local\bin\wezterm-gui.exe"
    goto :end
)

if exist "%LOCALAPPDATA%\Programs\WezTerm\wezterm-gui.exe" (
    start "" "%LOCALAPPDATA%\Programs\WezTerm\wezterm-gui.exe"
    goto :end
)

REM WezTerm не найден
echo [ERROR] WezTerm не найден!
echo.
echo Установите WezTerm одним из способов:
echo   scoop install wezterm
echo   choco install wezterm
echo   winget install wez.wezterm
echo.
echo Или скачайте с: https://wezfurlong.org/wezterm/install/windows.html
echo.
pause
exit /b 1

:end
endlocal

