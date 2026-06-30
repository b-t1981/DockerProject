# Lance WordPress avec Laragon Portable (sans Docker)
# Usage : .\lancer.ps1

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
$wpDir = Join-Path $root "wordpress"
$dataWp = Join-Path $wpDir "data\wordpress"
$wwwDir = Join-Path $PSScriptRoot "laragon\www\wordpress"
$laragonExe = Join-Path $PSScriptRoot "laragon\laragon.exe"
$sqlFile = Join-Path $wpDir "data\backup\site.sql"

# Charger .env
$envFile = Join-Path $wpDir ".env"
if (-not (Test-Path $envFile)) {
    Copy-Item (Join-Path $wpDir ".env.example") $envFile
}
Get-Content $envFile | ForEach-Object {
    if ($_ -match "^([^#=]+)=(.*)$") {
        Set-Variable -Name $matches[1] -Value $matches[2] -Scope Script
    }
}
$db   = if ($MYSQL_DATABASE) { $MYSQL_DATABASE } else { "wordpress" }
$user = if ($MYSQL_USER) { $MYSQL_USER } else { "wpuser" }
$pass = if ($MYSQL_PASSWORD) { $MYSQL_PASSWORD } else { "wppass" }

if (-not (Test-Path $laragonExe)) {
    Write-Host "Laragon introuvable. Lancez install-laragon.ps1"
    & (Join-Path $PSScriptRoot "install-laragon.ps1")
    exit 1
}

# Synchroniser les fichiers WordPress
Write-Host "Synchronisation des fichiers WordPress..."
New-Item -ItemType Directory -Force -Path $wwwDir | Out-Null
if (Test-Path $dataWp) {
    robocopy $dataWp $wwwDir /MIR /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
}

# Demarrer Laragon
Write-Host "Demarrage de Laragon (Apache + MariaDB)..."
Start-Process $laragonExe -ArgumentList "start" -WindowStyle Hidden
Start-Sleep -Seconds 12

# Importer la base si disponible
$mysql = Get-ChildItem -Path (Join-Path $PSScriptRoot "laragon\bin\mysql") -Recurse -Filter "mysql.exe" -ErrorAction SilentlyContinue |
    Where-Object { $_.DirectoryName -match "\\bin$" } |
    Select-Object -First 1

if ($mysql -and (Test-Path $sqlFile)) {
  Write-Host "Import de la base de donnees..."
  & $mysql.FullName -u root --execute="CREATE DATABASE IF NOT EXISTS ``$db``; CREATE USER IF NOT EXISTS '$user'@'localhost' IDENTIFIED BY '$pass'; GRANT ALL ON ``$db``.* TO '$user'@'localhost'; FLUSH PRIVILEGES;" 2>$null
  Get-Content $sqlFile -Raw | & $mysql.FullName -u root $db 2>$null
}

Write-Host ""
Write-Host "WordPress : http://localhost/wordpress"
Write-Host "Arreter   : .\arreter.ps1 (sauvegarde automatique)"
Start-Process "http://localhost/wordpress"
