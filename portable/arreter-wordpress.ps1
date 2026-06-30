# Arrete WordPress (garde les donnees dans wordpress/data/)
$docker = Join-Path $PSScriptRoot "bin\docker.exe"
$wpDir = Join-Path $PSScriptRoot "..\wordpress"

if (-not (Test-Path $docker)) {
    Write-Error "docker.exe manquant. Lancez install.ps1"
}

Set-Location $wpDir
& $docker compose down
Write-Host "WordPress arrete. Donnees conservees dans wordpress\data\"
