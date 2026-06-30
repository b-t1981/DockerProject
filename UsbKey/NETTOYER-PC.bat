@echo off
REM Supprime la trace WSL sur le PC invite apres la demo
cd /d "%~dp0"
echo Suppression de la distro WSL DockerProject...
wsl --unregister DockerProject 2>nul
echo Termine. Aucune trace sur ce PC.
pause
