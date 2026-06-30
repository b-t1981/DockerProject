# Construit l'archive Linux+Docker pour la cle USB
# Usage : .\build-distro.ps1

$ErrorActionPreference = "Stop"
$distroName = "DockerProject"
$tarFile = Join-Path $PSScriptRoot "docker-linux.tar"
$buildDir = Join-Path $PSScriptRoot "build-temp"
$rootfsTar = Join-Path $env:TEMP "ubuntu-wsl.rootfs.tar.gz"
$rootfsUrl = "https://cloud-images.ubuntu.com/wsl/releases/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz"

Write-Host "=== Construction Linux + Docker pour cle USB ==="
Write-Host ""

# Verifier WSL
wsl --status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) {
    Write-Host "WSL requis. En admin : wsl --install"
    exit 1
}

# Nettoyer
wsl --unregister $distroName 2>$null | Out-Null
if (Test-Path $buildDir) { Remove-Item -Recurse -Force $buildDir }
if (Test-Path $tarFile) { Remove-Item -Force $tarFile }
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null

Write-Host "[1/4] Telechargement Ubuntu WSL (~350 Mo)..."
if (-not (Test-Path $rootfsTar)) {
    curl.exe -L -o $rootfsTar $rootfsUrl
}

Write-Host "[2/4] Import Ubuntu..."
wsl --import $distroName $buildDir $rootfsTar --version 2

Write-Host "[3/4] Installation Docker Engine..."
$setupScript = @'
#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq ca-certificates curl
curl -fsSL https://get.docker.com | sh
echo "OK: $(docker --version)"
'@

$setupScript | wsl -d $distroName -u root -e bash

Write-Host "[4/4] Export docker-linux.tar (plusieurs minutes)..."
wsl --export $distroName $tarFile
wsl --unregister $distroName 2>$null | Out-Null
Remove-Item -Recurse -Force $buildDir -ErrorAction SilentlyContinue

$size = [math]::Round((Get-Item $tarFile).Length / 1MB)
Write-Host ""
Write-Host "Termine : $tarFile ($size Mo)"
Write-Host "Copiez le sur votre cle USB dans docker-vm\wsl\"
