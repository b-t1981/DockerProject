@echo off
REM Lance WordPress : Docker si disponible, sinon Laragon portable (sans Docker)
cd /d "%~dp0"

where docker >nul 2>&1
if %errorlevel%==0 (
    docker info >nul 2>&1
    if %errorlevel%==0 (
        echo Mode Docker detecte
        powershell -ExecutionPolicy Bypass -File "%~dp0portable\lancer-wordpress.ps1"
        goto fin
    )
)

echo Docker non disponible - mode Laragon portable
powershell -ExecutionPolicy Bypass -File "%~dp0sans-docker\lancer.ps1"

:fin
pause
