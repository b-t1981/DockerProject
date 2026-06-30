# Demarre WordPress avec le client Docker portable
# Mode local : utilise Docker Desktop s'il tourne sur ce PC
# Mode distant : lancez d'abord .\setup-remote.ps1

$ErrorActionPreference = "Stop"
$portable = $PSScriptRoot
$docker = Join-Path $portable "bin\docker.exe"
$wpDir = Join-Path $portable "..\wordpress"

if (-not (Test-Path $docker)) {
    & (Join-Path $portable "install.ps1")
}

if (-not (Test-Path (Join-Path $wpDir ".env"))) {
    Copy-Item (Join-Path $wpDir ".env.example") (Join-Path $wpDir ".env")
    Write-Host ".env cree depuis .env.example"
}

Set-Location $wpDir
Write-Host "Demarrage WordPress..."
& $docker compose up -d

Write-Host ""
Write-Host "WordPress  : http://localhost:8080"
Write-Host "phpMyAdmin : http://localhost:8081"
Write-Host ""
Write-Host "Arreter : ..\portable\arreter-wordpress.ps1"
