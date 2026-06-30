# Importe Linux+Docker depuis la cle USB sur ce PC
# Usage : .\install-distro.ps1

$ErrorActionPreference = "Stop"
$distroName = "DockerProject"
$tarFile = Join-Path $PSScriptRoot "docker-linux.tar"
$installDir = Join-Path $PSScriptRoot "distro"

if (-not (Test-Path $tarFile)) {
    Write-Host "Archive introuvable : $tarFile"
    Write-Host "Lancez d'abord build-distro.ps1 sur votre PC principal."
    exit 1
}

$existing = wsl -l -q 2>$null | Where-Object { $_ -match $distroName }
if ($existing) {
    Write-Host "Distro '$distroName' deja installee."
    exit 0
}

Write-Host "Import Linux + Docker depuis la cle USB..."
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
wsl --import $distroName $installDir $tarFile --version 2

Write-Host "Distro '$distroName' installee."
Write-Host "Lancez : .\lancer.ps1"
