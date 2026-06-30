# Arrete WordPress (Docker Desktop ou WSL Linux)
$ErrorActionPreference = "SilentlyContinue"

$projectRoot = Split-Path -Parent $PSScriptRoot

# Docker Desktop
$docker = Join-Path $projectRoot "portable\bin\docker.exe"
if (Test-Path $docker) {
    Set-Location (Join-Path $projectRoot "wordpress")
    & $docker compose down 2>$null
}

# WSL Linux embarque
$wslStop = Join-Path $projectRoot "docker-vm\wsl\arreter.ps1"
if (Test-Path $wslStop) { & $wslStop }

Write-Host "Arrete. Donnees dans wordpress\data\"
