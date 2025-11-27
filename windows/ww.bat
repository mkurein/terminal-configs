@echo off
setlocal EnableDelayedExpansion
REM ============================================================================
REM  ww.bat - Быстрый запуск WezTerm в текущей папке Windows + WSL
REM ============================================================================

set "CONFIG_DIR=%USERPROFILE%\.config\wezterm"
set "CONFIG_FILE=%CONFIG_DIR%\wezterm.lua"
set "SOURCE_CONFIG=%~dp0wezterm\wezterm.lua"
set "WINPATH=%cd%"

if not exist "%CONFIG_DIR%" (
    echo Creating config directory: %CONFIG_DIR%
    mkdir "%CONFIG_DIR%"
)

if not exist "%CONFIG_FILE%" if exist "%SOURCE_CONFIG%" (
    echo Copying WezTerm config to %CONFIG_DIR%...
    copy "%SOURCE_CONFIG%" "%CONFIG_FILE%" >nul
)

REM Convert Windows path to WSL path (C:\foo\bar -> /mnt/c/foo/bar)
set "DRIVE=%WINPATH:~0,1%"
set "REST=%WINPATH:~2%"
set "REST=%REST:\=/%"

REM Convert drive letter to lowercase
call :toLower DRIVE

set "WSLPATH=/mnt/%DRIVE%%REST%"

REM Find WezTerm executable
set "WEZTERM_EXE="
for /f "delims=" %%i in ('where wezterm.exe 2^>nul') do if not defined WEZTERM_EXE set "WEZTERM_EXE=%%i"

if not defined WEZTERM_EXE (
    for /f "delims=" %%i in ('where wezterm-gui.exe 2^>nul') do if not defined WEZTERM_EXE set "WEZTERM_EXE=%%i"
)

if not defined WEZTERM_EXE if exist "%USERPROFILE%\scoop\apps\wezterm\current\wezterm.exe" set "WEZTERM_EXE=%USERPROFILE%\scoop\apps\wezterm\current\wezterm.exe"
if not defined WEZTERM_EXE if exist "%USERPROFILE%\scoop\apps\wezterm\current\wezterm-gui.exe" set "WEZTERM_EXE=%USERPROFILE%\scoop\apps\wezterm\current\wezterm-gui.exe"
if not defined WEZTERM_EXE if exist "%USERPROFILE%\.local\bin\wezterm.exe" set "WEZTERM_EXE=%USERPROFILE%\.local\bin\wezterm.exe"
if not defined WEZTERM_EXE if exist "%USERPROFILE%\.local\bin\wezterm-gui.exe" set "WEZTERM_EXE=%USERPROFILE%\.local\bin\wezterm-gui.exe"
if not defined WEZTERM_EXE if exist "C:\Program Files\WezTerm\wezterm.exe" set "WEZTERM_EXE=C:\Program Files\WezTerm\wezterm.exe"
if not defined WEZTERM_EXE if exist "C:\Program Files\WezTerm\wezterm-gui.exe" set "WEZTERM_EXE=C:\Program Files\WezTerm\wezterm-gui.exe"
if not defined WEZTERM_EXE if exist "%LOCALAPPDATA%\Programs\WezTerm\wezterm.exe" set "WEZTERM_EXE=%LOCALAPPDATA%\Programs\WezTerm\wezterm.exe"
if not defined WEZTERM_EXE if exist "%LOCALAPPDATA%\Programs\WezTerm\wezterm-gui.exe" set "WEZTERM_EXE=%LOCALAPPDATA%\Programs\WezTerm\wezterm-gui.exe"

if not defined WEZTERM_EXE (
    echo [ERROR] WezTerm not found!
    echo Install it via scoop/choco/winget and try again.
    pause
    exit /b 1
)

start "" "%WEZTERM_EXE%" start -- wsl.exe /usr/bin/zsh -l -c "cd '%WSLPATH%' && exec zsh"

endlocal
goto :eof

:toLower
REM Convert variable to lowercase
set "_val=!%1!"
for %%a in (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    set "_val=!_val:%%a=%%a!"
)
set "_val=!_val:A=a!"
set "_val=!_val:B=b!"
set "_val=!_val:C=c!"
set "_val=!_val:D=d!"
set "_val=!_val:E=e!"
set "_val=!_val:F=f!"
set "_val=!_val:G=g!"
set "_val=!_val:H=h!"
set "_val=!_val:I=i!"
set "_val=!_val:J=j!"
set "_val=!_val:K=k!"
set "_val=!_val:L=l!"
set "_val=!_val:M=m!"
set "_val=!_val:N=n!"
set "_val=!_val:O=o!"
set "_val=!_val:P=p!"
set "_val=!_val:Q=q!"
set "_val=!_val:R=r!"
set "_val=!_val:S=s!"
set "_val=!_val:T=t!"
set "_val=!_val:U=u!"
set "_val=!_val:V=v!"
set "_val=!_val:W=w!"
set "_val=!_val:X=x!"
set "_val=!_val:Y=y!"
set "_val=!_val:Z=z!"
set "%1=!_val!"
goto :eof
