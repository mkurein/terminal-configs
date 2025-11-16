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

REM Получить папку, где находится этот bat-файл
set "BATDIR=%~dp0"
REM Убрать завершающий слэш
set "BATDIR=%BATDIR:~0,-1%"

REM Конвертировать путь к папке bat-файла в WSL формат
for /f "delims=" %%i in ('wsl wslpath -u "%BATDIR%"') do set WSLPATH=%%i

REM Запустить Alacritty с переходом в папку bat-файла в WSL
start "" "C:\Program Files\Alacritty\alacritty.exe" -e wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"

