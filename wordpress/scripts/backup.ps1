# Sauvegarde complète du site (base + fichiers)
# Usage : .\scripts\backup.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$dest = Join-Path $root "backups\$timestamp"
New-Item -ItemType Directory -Force -Path $dest | Out-Null

Write-Host "Sauvegarde de la base de donnees..."
docker compose exec -T db mysqldump -u wpuser -pwppass wordpress | Out-File -Encoding utf8 (Join-Path $dest "database.sql")

Write-Host "Copie des fichiers WordPress..."
$dataSrc = Join-Path $root "data"
if (Test-Path $dataSrc) {
    Copy-Item -Recurse -Force $dataSrc (Join-Path $dest "data")
}

if (Test-Path (Join-Path $root ".env")) {
    Copy-Item (Join-Path $root ".env") (Join-Path $dest ".env")
}

Write-Host "Sauvegarde terminee : $dest"
