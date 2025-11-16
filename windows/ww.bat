@echo off
REM ============================================================================
REM  ww.bat - Быстрый запуск WezTerm в текущей папке Windows + WSL
REM ============================================================================
REM 
REM ОПИСАНИЕ:
REM   Открывает WezTerm в текущей папке проводника с автоматическим
REM   переходом в WSL и запуском zsh
REM 
REM УСТАНОВКА:
REM   1. Скопируйте этот файл в C:\Windows\System32\
REM      (Требуются права администратора)
REM   
REM   PowerShell команда (от администратора):
REM   Copy-Item ww.bat C:\Windows\System32\
REM 
REM ИСПОЛЬЗОВАНИЕ:
REM   Вариант 1: Через адресную строку проводника
REM     - Откройте любую папку в проводнике
REM     - Кликните в адресную строку
REM     - Введите: ww
REM     - Нажмите Enter
REM     - WezTerm откроется в этой папке в WSL!
REM 
REM   Вариант 2: Через контекстное меню
REM     - Используйте wezterm-here.reg для добавления в меню
REM     - ПКМ на фоне папки → "Open WezTerm Here"
REM 
REM   Вариант 3: Из командной строки
REM     - cd C:\Your\Project\Folder
REM     - ww
REM 
REM ТРЕБОВАНИЯ:
REM   - Windows 11 или Windows 10 с WSL2
REM   - WezTerm установлен в "C:\Users\%USERNAME%\.local\bin\" (Scoop)
REM     или в "C:\Program Files\WezTerm\"
REM   - WSL с Debian или Ubuntu настроен
REM 
REM ============================================================================

REM Конвертировать текущий путь в WSL формат
for /f "delims=" %%i in ('wsl wslpath -u "%cd%"') do set WSLPATH=%%i

REM Попробовать найти WezTerm (Scoop устанавливает в .local\bin)
if exist "%USERPROFILE%\.local\bin\wezterm-gui.exe" (
    start "" "%USERPROFILE%\.local\bin\wezterm-gui.exe" start -- wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"
) else if exist "C:\Program Files\WezTerm\wezterm-gui.exe" (
    start "" "C:\Program Files\WezTerm\wezterm-gui.exe" start -- wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"
) else (
    echo [ERROR] WezTerm не найден!
    echo.
    echo Установите WezTerm:
    echo   scoop install wezterm
    echo   choco install wezterm
    echo   winget install wez.wezterm
    echo.
    echo Или укажите правильный путь в ww.bat
    pause
)

