# Assemble le dossier UsbKey pret a copier sur cle USB
# Usage : .\prepare-usbkey.ps1

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$usbRoot = $PSScriptRoot

Write-Host "=== Preparation UsbKey ==="
Write-Host ""

# 1. Archives Linux + Docker
$srcLinux = Join-Path $projectRoot "docker-vm\wsl\docker-linux.tar"
$srcImages = Join-Path $projectRoot "docker-vm\wsl\images.tar"
$dstWsl = Join-Path $usbRoot "wsl"

if (-not (Test-Path $srcLinux)) {
    Write-Host "ERREUR : docker-linux.tar manquant."
    Write-Host "Executez : cd docker-vm\wsl && .\build-distro.ps1"
    exit 1
}

New-Item -ItemType Directory -Force -Path $dstWsl | Out-Null

Write-Host "[1/3] Copie docker-linux.tar (~4 Go)..."
Copy-Item $srcLinux (Join-Path $dstWsl "docker-linux.tar") -Force

if (Test-Path $srcImages) {
    Write-Host "[2/3] Copie images.tar (~640 Mo)..."
    Copy-Item $srcImages (Join-Path $dstWsl "images.tar") -Force
} else {
    Write-Host "[2/3] images.tar absent - ignore"
}

# 2. WordPress (compose, custom, data, env)
Write-Host "[3/3] Copie WordPress..."
$dstWp = Join-Path $usbRoot "wordpress"
$srcWp = Join-Path $projectRoot "wordpress"

if (Test-Path $dstWp) { Remove-Item -Recurse -Force $dstWp }

robocopy $srcWp $dstWp /E /XD backups /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null

# Fichiers essentiels seulement si robocopy trop large
foreach ($f in @("docker-compose.yml", ".env.example")) {
    if (-not (Test-Path (Join-Path $dstWp $f))) {
        Copy-Item (Join-Path $srcWp $f) (Join-Path $dstWp $f) -Force
    }
}
if (-not (Test-Path (Join-Path $dstWp "custom"))) {
    robocopy (Join-Path $srcWp "custom") (Join-Path $dstWp "custom") /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
}
if (-not (Test-Path (Join-Path $dstWp "data"))) {
    robocopy (Join-Path $srcWp "data") (Join-Path $dstWp "data") /E /NFL /NDL /NJH /NJS /nc /ns /np | Out-Null
}

# .env si existe
if (Test-Path (Join-Path $srcWp ".env")) {
    Copy-Item (Join-Path $srcWp ".env") (Join-Path $dstWp ".env") -Force
} elseif (-not (Test-Path (Join-Path $dstWp ".env"))) {
    Copy-Item (Join-Path $dstWp ".env.example") (Join-Path $dstWp ".env") -Force
}

# Nettoyer distro locale si presente
Remove-Item -Recurse -Force (Join-Path $dstWsl "distro") -ErrorAction SilentlyContinue

$total = (Get-ChildItem $usbRoot -Recurse -File | Measure-Object -Property Length -Sum).Sum
$totalMo = [math]::Round($total / 1GB, 2)

Write-Host ""
Write-Host "UsbKey pret ! Taille totale : $totalMo Go"
Write-Host "Copiez le dossier UsbKey\ sur votre cle USB."
Write-Host ""
Write-Host "Sur PC invite : double-clic LANCER.bat"
