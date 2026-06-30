# Importe Linux+Docker depuis la cle USB
$ErrorActionPreference = "Stop"
$distroName = "DockerProject"
$tarFile = Join-Path $PSScriptRoot "docker-linux.tar"
$installDir = Join-Path $PSScriptRoot "distro"

if (-not (Test-Path $tarFile)) {
    Write-Host "Fichier manquant : $tarFile"
    Write-Host "Executez prepare-usbkey.ps1 sur votre PC principal."
    exit 1
}

$existing = wsl -l -q 2>$null | Where-Object { $_ -match $distroName }
if ($existing) {
    Write-Host "Distro deja installee."
    exit 0
}

Write-Host "Import Linux + Docker depuis la cle USB..."
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
wsl --import $distroName $installDir $tarFile --version 2
Write-Host "Import termine."
