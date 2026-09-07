@echo off
setlocal
cd /d "%~dp0"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0run_beans.ps1"
set EXITCODE=%ERRORLEVEL%
endlocal & exit /b %EXITCODE%
