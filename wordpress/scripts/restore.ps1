# Restaure une sauvegarde creee par backup.ps1
# Usage : .\scripts\restore.ps1 -BackupDir "backups\20260630-120000"

param(
    [Parameter(Mandatory = $true)]
    [string]$BackupDir
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$src = Join-Path $root $BackupDir
if (-not (Test-Path $src)) {
    Write-Error "Dossier introuvable : $src"
}

Write-Host "Arret des conteneurs..."
docker compose down

if (Test-Path (Join-Path $src "data")) {
    Write-Host "Restauration des fichiers data..."
    Remove-Item -Recurse -Force (Join-Path $root "data") -ErrorAction SilentlyContinue
    Copy-Item -Recurse -Force (Join-Path $src "data") (Join-Path $root "data")
}

if (Test-Path (Join-Path $src ".env")) {
    Copy-Item -Force (Join-Path $src ".env") (Join-Path $root ".env")
}

Write-Host "Demarrage des conteneurs..."
docker compose up -d

$db = Join-Path $src "database.sql"
if (Test-Path $db) {
    Write-Host "Attente du demarrage de MariaDB..."
    Start-Sleep -Seconds 15
    Write-Host "Restauration de la base..."
    Get-Content $db | docker compose exec -T db mysql -u wpuser -pwppass wordpress
}

Write-Host "Restauration terminee."
