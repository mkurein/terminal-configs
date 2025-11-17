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
REM   - WezTerm установлен (Scoop, winget, или вручную)
REM   - WSL с zsh настроен
REM 
REM ============================================================================

setlocal

for /f "delims=" %%i in ('wsl wslpath -u "%cd%"') do set "WSLPATH=%%i"

rem Попробовать найти WezTerm через where (поиск в PATH)
where wezterm.exe >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start "" wezterm.exe start -- wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

rem Попробовать стандартные пути установки
if exist "%USERPROFILE%\.local\bin\wezterm.exe" (
    start "" "%USERPROFILE%\.local\bin\wezterm.exe" start -- wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

if exist "C:\Program Files\WezTerm\wezterm.exe" (
    start "" "C:\Program Files\WezTerm\wezterm.exe" start -- wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

if exist "%LOCALAPPDATA%\Programs\WezTerm\wezterm.exe" (
    start "" "%LOCALAPPDATA%\Programs\WezTerm\wezterm.exe" start -- wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"
    goto :end
)

rem WezTerm не найден
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

