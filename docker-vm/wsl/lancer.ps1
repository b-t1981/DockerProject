# Demarre Docker dans WSL Linux et lance WordPress
# Usage : .\lancer.ps1

$ErrorActionPreference = "Stop"
$distroName = "DockerProject"
$tarFile = Join-Path $PSScriptRoot "docker-linux.tar"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$wpDir = Join-Path $projectRoot "wordpress"

# Installer la distro si necessaire
$existing = wsl -l -q 2>$null | Where-Object { $_ -match $distroName }
if (-not $existing) {
    if (-not (Test-Path $tarFile)) {
        Write-Host "docker-linux.tar introuvable. Executez build-distro.ps1 d'abord."
        exit 1
    }
    & (Join-Path $PSScriptRoot "install-distro.ps1")
}

# Convertir chemin Windows en chemin WSL
function Win-ToWsl($path) {
    $p = $path -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)') {
        return "/mnt/$($matches[1].ToLower())$($matches[2])"
    }
    return $p
}

$wslProject = Win-ToWsl $projectRoot
$wslWp = Win-ToWsl $wpDir

# .env
$envFile = Join-Path $wpDir ".env"
if (-not (Test-Path $envFile)) {
    Copy-Item (Join-Path $wpDir ".env.example") $envFile
}

Write-Host "Demarrage Docker dans Linux (WSL)..."
$launchScript = @"
#!/bin/bash
set -e
sudo service docker start 2>/dev/null || sudo dockerd > /tmp/dockerd.log 2>&1 &
sleep 3
until docker info >/dev/null 2>&1; do sleep 1; done
cd '$wslWp'
if [ ! -f .env ]; then cp .env.example .env; fi
docker compose up --build -d
echo ''
echo 'WordPress  : http://localhost:8080'
echo 'phpMyAdmin : http://localhost:8081'
"@

$launchScript | wsl -d $distroName -e bash

Write-Host ""
Write-Host "WordPress : http://localhost:8080"
Start-Process "http://localhost:8080"
