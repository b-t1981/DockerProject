@echo off
REM Docker ou rien : Docker Desktop OU Linux WSL embarque sur la cle USB
cd /d "%~dp0"

where docker >nul 2>&1
if %errorlevel%==0 (
    docker info >nul 2>&1
    if %errorlevel%==0 (
        echo [Mode 1] Docker Desktop detecte
        powershell -ExecutionPolicy Bypass -File "%~dp0portable\lancer-wordpress.ps1"
        goto fin
    )
)

if exist "%~dp0docker-vm\wsl\docker-linux.tar" (
    echo [Mode 2] Linux+Docker embarque via WSL
    powershell -ExecutionPolicy Bypass -File "%~dp0docker-vm\wsl\lancer.ps1"
    goto fin
)

echo [Mode 3] Tentative VM Linux VirtualBox...
powershell -ExecutionPolicy Bypass -File "%~dp0docker-vm\vbox\lancer.ps1"
if %errorlevel%==0 goto fin

echo.
echo Aucun moteur Docker disponible.
echo Sur votre PC principal : cd docker-vm\wsl ^&^& .\build-distro.ps1
echo Puis copiez docker-linux.tar sur la cle USB.
echo.

:fin
pause
