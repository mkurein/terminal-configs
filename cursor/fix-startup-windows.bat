@echo off
setlocal EnableExtensions DisableDelayedExpansion
title Cursor - one IDE window
chcp 65001 >nul
set "PYTHONUTF8=1"
set "CURSOR_FIX_EXIT=1"

echo Cursor startup repair: one IDE window.
echo Save your work and fully close Cursor before running this file.
echo A local backup will be created; temporary workspaces will be archived.
echo.

pushd "%~dp0"
if errorlevel 1 goto directory_error

if not exist "fix-startup-windows.py" goto files_missing
if not exist "cursor_startup.py" goto files_missing
if not exist "settings.json" goto files_missing

py -3 -c "import sys, sqlite3; assert sys.version_info.major == 3 and sys.platform == 'win32'" >nul 2>&1
if not errorlevel 1 goto use_py
python -c "import sys, sqlite3; assert sys.version_info.major == 3 and sys.platform == 'win32'" >nul 2>&1
if not errorlevel 1 goto use_python

echo ERROR: Python 3 with SQLite support was not found.
echo Install Python 3 for Windows from https://www.python.org/downloads/windows/
echo Enable the Python launcher or add Python to PATH, then run this file again.
goto finish

:use_py
py -3 "%~dp0fix-startup-windows.py" --apply --archive-workspaces
goto capture_result

:use_python
python "%~dp0fix-startup-windows.py" --apply --archive-workspaces

:capture_result
set "CURSOR_FIX_EXIT=%errorlevel%"
if not "%CURSOR_FIX_EXIT%"=="0" goto repair_error
echo.
echo SUCCESS: Settings applied. Open Cursor and check that only one IDE window appears.
echo The backup location is printed above.
goto finish

:repair_error
echo.
echo ERROR: Repair did not finish successfully. Read the details above.
echo If Cursor is running, fully close it and run this file again.
echo See README.md for JSON settings requirements and backup recovery.
goto finish

:files_missing
echo ERROR: Required files are missing. Keep the entire cursor folder together.
echo Required: fix-startup-windows.py, cursor_startup.py, settings.json.
goto finish

:directory_error
echo ERROR: Could not open the folder containing this file.
pause
exit /b 1

:finish
popd
echo.
pause
exit /b %CURSOR_FIX_EXIT%
