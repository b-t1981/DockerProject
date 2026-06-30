@echo off
REM Lance WordPress via Linux WSL embarque (sans Docker Desktop)
cd /d "%~dp0"
echo [UsbKey] Demarrage WordPress + MariaDB via WSL Linux...
powershell -ExecutionPolicy Bypass -File "%~dp0wsl\lancer.ps1"
pause
