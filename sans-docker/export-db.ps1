# Exporte la base WordPress vers wordpress/data/backup/site.sql
# Fonctionne depuis Docker ou depuis Laragon

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$wpDir = Join-Path $root "wordpress"
$backupDir = Join-Path $wpDir "data\backup"
$sqlFile = Join-Path $backupDir "site.sql"

New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

# Charger .env
$envFile = Join-Path $wpDir ".env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^([^#=]+)=(.*)$") {
            Set-Variable -Name $matches[1] -Value $matches[2] -Scope Script
        }
    }
}

$user = if ($MYSQL_USER) { $MYSQL_USER } else { "wpuser" }
$pass = if ($MYSQL_PASSWORD) { $MYSQL_PASSWORD } else { "wppass" }
$db   = if ($MYSQL_DATABASE) { $MYSQL_DATABASE } else { "wordpress" }

# Mode Docker : conteneur db actif
Set-Location $wpDir
$dockerRunning = docker compose ps --status running -q db 2>$null

if ($dockerRunning) {
    Write-Host "Export depuis Docker..."
    docker compose exec -T db mysqldump -u $user -p$pass $db | Out-File -Encoding utf8 $sqlFile
    Write-Host "Sauvegarde : $sqlFile"
    exit 0
}

# Mode Laragon : mysql local
$laragon = Join-Path $PSScriptRoot "laragon"
$mysql = Get-ChildItem -Path (Join-Path $laragon "bin\mysql") -Recurse -Filter "mysql.exe" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -match "\\bin\\mysql\.exe$" } |
    Select-Object -First 1

if ($mysql) {
    Write-Host "Export depuis Laragon..."
    & $mysql.FullName -u root --execute="CREATE DATABASE IF NOT EXISTS $db;" 2>$null
    & $mysql.FullName -u root $db -e "SELECT 1" 2>$null | Out-Null
    $mysqldump = Join-Path (Split-Path $mysql.FullName) "mysqldump.exe"
    if (Test-Path $mysqldump) {
        & $mysqldump -u root $db 2>$null | Out-File -Encoding utf8 $sqlFile
        Write-Host "Sauvegarde : $sqlFile"
        exit 0
    }
}

Write-Host "Aucun moteur de base detecte (Docker ou Laragon)."
