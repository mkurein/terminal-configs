@echo off
REM ============================================================================
REM  wa.bat - Быстрый запуск Alacritty в текущей папке Windows + WSL
REM ============================================================================
REM 
REM ОПИСАНИЕ:
REM   Открывает Alacritty в текущей папке проводника с автоматическим
REM   переходом в WSL и запуском zsh
REM 
REM УСТАНОВКА:
REM   1. Скопируйте этот файл в C:\Windows\System32\
REM      (Требуются права администратора)
REM   
REM   PowerShell команда (от администратора):
REM   Copy-Item wa.bat C:\Windows\System32\
REM 
REM ИСПОЛЬЗОВАНИЕ:
REM   Вариант 1: Через адресную строку проводника
REM     - Откройте любую папку в проводнике
REM     - Кликните в адресную строку
REM     - Введите: wa
REM     - Нажмите Enter
REM     - Alacritty откроется в этой папке в WSL!
REM 
REM   Вариант 2: Через контекстное меню
REM     - Используйте alacritty-here.reg для добавления в меню
REM     - ПКМ на фоне папки → "Open Alacritty Here"
REM 
REM   Вариант 3: Из командной строки
REM     - cd C:\Your\Project\Folder
REM     - wa
REM 
REM ТРЕБОВАНИЯ:
REM   - Windows 11 или Windows 10 с WSL2
REM   - Alacritty установлен в "C:\Program Files\Alacritty\"
REM   - WSL с zsh настроен
REM 
REM ============================================================================

for /f "delims=" %%i in ('wsl wslpath -u "%cd%"') do set WSLPATH=%%i
start "" "C:\Program Files\Alacritty\alacritty.exe" -e wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"