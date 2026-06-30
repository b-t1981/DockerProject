@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0wsl\arreter.ps1"
pause
