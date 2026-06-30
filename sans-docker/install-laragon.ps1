# Installe Laragon Portable dans sans-docker/laragon/
# Usage : .\install-laragon.ps1

$ErrorActionPreference = "Stop"
$dest = Join-Path $PSScriptRoot "laragon"
$laragonExe = Join-Path $dest "laragon.exe"

if (Test-Path $laragonExe) {
    Write-Host "Laragon deja installe : $dest"
    exit 0
}

Write-Host ""
Write-Host "Laragon Portable doit etre installe manuellement."
Write-Host ""
Write-Host "1. Telechargez Laragon Portable : https://laragon.org/download/"
Write-Host "2. Extrayez le contenu dans :"
Write-Host "   $dest"
Write-Host "3. Verifiez que ce fichier existe :"
Write-Host "   $laragonExe"
Write-Host ""
Write-Host "Ouverture du site de telechargement..."
Start-Process "https://laragon.org/download/"

New-Item -ItemType Directory -Force -Path $dest | Out-Null
