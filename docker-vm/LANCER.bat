@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0lancer.ps1"
pause
