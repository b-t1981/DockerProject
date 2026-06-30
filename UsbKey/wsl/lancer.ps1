# Demarre WordPress via WSL Linux embarque (hors ligne)
$ErrorActionPreference = "Stop"
$distroName = "DockerProject"
$usbRoot = Split-Path -Parent $PSScriptRoot
$wpDir = Join-Path $usbRoot "wordpress"
$tarFile = Join-Path $PSScriptRoot "docker-linux.tar"
$imagesTar = Join-Path $PSScriptRoot "images.tar"

function Win-ToWsl($path) {
    $p = $path -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)') { return "/mnt/$($matches[1].ToLower())$($matches[2])" }
    return $p
}

$existing = wsl -l -q 2>$null | Where-Object { $_ -match $distroName }
if (-not $existing) {
    & (Join-Path $PSScriptRoot "install-distro.ps1")
}

$envFile = Join-Path $wpDir ".env"
if (-not (Test-Path $envFile)) {
    Copy-Item (Join-Path $wpDir ".env.example") $envFile
}

$wslWp = Win-ToWsl $wpDir
$wslImages = Win-ToWsl $imagesTar

$launchScript = @"
#!/bin/bash
set -e
dockerd --iptables=false --ip6tables=false > /tmp/dockerd.log 2>&1 &
for i in `$(seq 1 30); do docker info >/dev/null 2>&1 && break; sleep 1; done
if [ -f '$wslImages' ]; then
  docker image inspect mariadb:11 >/dev/null 2>&1 || docker load -i '$wslImages'
fi
docker tag wordpress:latest wordpress:6-apache 2>/dev/null || true
cd '$wslWp'
[ -f .env ] || cp .env.example .env
if docker image inspect wordpress-wordpress:latest >/dev/null 2>&1; then
  docker compose up -d --no-build
else
  docker compose up -d
fi
echo ''
echo 'WordPress  : http://localhost:8080'
echo 'phpMyAdmin : http://localhost:8081'
"@

$launchScript = $launchScript.Replace("`r`n", "`n")
$launchScript | wsl -d $distroName -u root -e bash

Write-Host ""
Write-Host "WordPress : http://localhost:8080"
Start-Process "http://localhost:8080"
