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
REM     cd "/mnt/c/Users/z6364/OneDrive/Рабочий стол"
REM   
REM   Для запуска WezTerm в конкретной папке используйте команду "ww" 
REM   в адресной строке проводника (работает с любыми путями, включая кириллицу)
REM 
REM ============================================================================

REM Запустить WezTerm (откроется в домашней папке WSL по умолчанию)
REM 
REM ПРИМЕЧАНИЕ: Автоматический переход в папку "Рабочий стол" не работает
REM из-за проблем с кириллицей в путях OneDrive. Используйте один из вариантов:
REM 
REM 1. В открывшемся WezTerm выполните:
REM    cd "/mnt/c/Users/z6364/OneDrive/Рабочий стол"
REM 
REM 2. Или используйте команду "ww" в адресной строке проводника
REM    для запуска WezTerm в любой папке (работает с кириллицей!)
REM
if exist "C:\Program Files\WezTerm\wezterm-gui.exe" (
    start "" "C:\Program Files\WezTerm\wezterm-gui.exe"
) else if exist "%USERPROFILE%\.local\bin\wezterm-gui.exe" (
    start "" "%USERPROFILE%\.local\bin\wezterm-gui.exe"
) else (
    echo [ERROR] WezTerm не найден!
    echo.
    echo Установите WezTerm:
    echo   scoop install wezterm
    echo.
    pause
)

