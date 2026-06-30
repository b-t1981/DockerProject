# Arrete WordPress (garde les donnees dans wordpress/data/)
$docker = Join-Path $PSScriptRoot "bin\docker.exe"
$wpDir = Join-Path $PSScriptRoot "..\wordpress"
$exportScript = Join-Path $PSScriptRoot "..\docker-vm\export-db.ps1"

if (-not (Test-Path $docker)) {
    Write-Error "docker.exe manquant. Lancez install.ps1"
}

Set-Location $wpDir
& $docker compose down

if (Test-Path $exportScript) {
    & $exportScript
}

Write-Host "WordPress arrete. Donnees dans wordpress\data\"
