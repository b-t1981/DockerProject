# Prepare une cle USB avec tout le necessaire
# Usage : .\pack-usb.ps1 -DriveLetter "E"

param(
    [Parameter(Mandatory = $true)]
    [string]$DriveLetter
)

$ErrorActionPreference = "Stop"
$drive = $DriveLetter.TrimEnd(':').TrimEnd('\') + ":\"
$dest = Join-Path $drive "DockerProject"

if (-not (Test-Path $drive)) {
    Write-Error "Lecteur introuvable : $drive"
}

$root = Split-Path -Parent $PSScriptRoot

# Installer docker.exe si absent
& (Join-Path $PSScriptRoot "install.ps1")

Write-Host "Copie vers $dest ..."
if (Test-Path $dest) { Remove-Item -Recurse -Force $dest }

$exclude = @(".git")
robocopy $root $dest /E /XD .git /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

Write-Host ""
Write-Host "Cle USB prete : $dest"
Write-Host ""
Write-Host "Sur le PC invite :"
Write-Host "  Double-clic sur LANCER.bat (racine du projet)"
Write-Host "  -> Docker si disponible, sinon Laragon portable"
Write-Host ""
Write-Host "Installez Laragon Portable dans : sans-docker\laragon\"
Write-Host "  https://laragon.org/download/"
Write-Host ""
Write-Host "Contenu embarque :"
Write-Host "  - portable\bin\docker.exe  (~43 Mo)"
Write-Host "  - wordpress\data\          (votre site)"
Write-Host "  - scripts de lancement"
