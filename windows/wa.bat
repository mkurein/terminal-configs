@echo off
REM Запуск Alacritty в текущей папке Windows с автоматическим переходом в WSL
REM Использование: wa.bat или через контекстное меню проводника
for /f "delims=" %%i in ('wsl wslpath -u "%cd%"') do set WSLPATH=%%i
start "" "C:\Program Files\Alacritty\alacritty.exe" -e wsl.exe bash -c "cd '%WSLPATH%' && exec zsh"