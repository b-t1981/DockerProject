# Arrete Laragon et sauvegarde la base
$laragonExe = Join-Path $PSScriptRoot "laragon\laragon.exe"

& (Join-Path $PSScriptRoot "export-db.ps1")

# Copier les fichiers WordPress vers data/
$root = Split-Path -Parent $PSScriptRoot
$wwwDir = Join-Path $PSScriptRoot "laragon\www\wordpress"
$dataWp = Join-Path $root "wordpress\data\wordpress"

if (Test-Path $wwwDir) {
    New-Item -ItemType Directory -Force -Path $dataWp | Out-Null
    robocopy $wwwDir $dataWp /MIR /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
    Write-Host "Fichiers sauvegardes dans wordpress\data\wordpress\"
}

if (Test-Path $laragonExe) {
    Start-Process $laragonExe -ArgumentList "stop" -WindowStyle Hidden -Wait
    Write-Host "Laragon arrete."
}
