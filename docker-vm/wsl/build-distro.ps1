# Construit Linux+Docker+images pour la cle USB (methode hors-ligne)
# Usage : .\build-distro.ps1

$ErrorActionPreference = "Stop"
$wslDir = $PSScriptRoot
$rootfsTar = Join-Path $env:TEMP "ubuntu-wsl.rootfs.tar.gz"
$rootfsUrl = "https://cloud-images.ubuntu.com/wsl/releases/noble/current/ubuntu-noble-wsl-amd64-wsl.rootfs.tar.gz"
$staticTgz = Join-Path $env:TEMP "docker-29.5.3.tgz"
$staticUrl = "https://download.docker.com/linux/static/stable/x86_64/docker-29.5.3.tgz"
$composeUrl = "https://github.com/docker/compose/releases/download/v2.39.1/docker-compose-linux-x86_64"
$dockerBin = Join-Path $wslDir "docker-bin"
$distroName = "DockerProject"
$tarFile = Join-Path $wslDir "docker-linux.tar"
$imagesTar = Join-Path $wslDir "images.tar"
$buildDir = Join-Path $wslDir "build-temp"

function Win-ToWsl($path) {
    $p = $path -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)') { return "/mnt/$($matches[1].ToLower())$($matches[2])" }
    return $p
}

Write-Host "=== Build Linux + Docker + images pour cle USB ==="

wsl --status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "WSL requis."; exit 1 }

# 1. Ubuntu rootfs
if (-not (Test-Path $rootfsTar)) {
    Write-Host "[1/5] Telechargement Ubuntu WSL..."
    curl.exe -L -o $rootfsTar $rootfsUrl
}

# 2. Docker static Linux
if (-not (Test-Path $staticTgz)) {
    Write-Host "[2/5] Telechargement Docker static Linux..."
    curl.exe -L -o $staticTgz $staticUrl
}
Remove-Item -Recurse -Force $dockerBin -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $dockerBin | Out-Null
tar -xzf $staticTgz -C $dockerBin
Copy-Item (Get-ChildItem $dockerBin -Recurse -Filter "docker-compose" -ErrorAction SilentlyContinue) "$dockerBin\docker-compose" -ErrorAction SilentlyContinue
if (-not (Test-Path "$dockerBin\docker-compose")) {
    curl.exe -L -o "$dockerBin\docker-compose" $composeUrl
}

# 3. Images Docker (depuis Docker Desktop si disponible)
if (-not (Test-Path $imagesTar)) {
    Write-Host "[3/5] Export images WordPress/MariaDB..."
    docker save mariadb:11 wordpress:latest phpmyadmin:latest wordpress-wordpress:latest -o $imagesTar 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Lancez d'abord WordPress avec Docker Desktop pour telecharger les images."
    }
}

# 4. Import + install Docker dans Linux
Write-Host "[4/5] Construction distro Linux..."
wsl --unregister $distroName 2>$null | Out-Null
Remove-Item -Recurse -Force $buildDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
wsl --import $distroName $buildDir $rootfsTar --version 2

$wslBin = Win-ToWsl $dockerBin

wsl -d $distroName -u root -e bash -lc "cp $wslBin/docker/* /usr/local/bin/ && chmod +x /usr/local/bin/* && mkdir -p /usr/local/lib/docker/cli-plugins && cp $wslBin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose && docker --version"

# Charger images dans la distro avant export
if (Test-Path $imagesTar) {
    $wslImg = Win-ToWsl $imagesTar
    wsl -d $distroName -u root -e bash -lc "dockerd --iptables=false --ip6tables=false > /tmp/d.log 2>&1 & sleep 12; docker load -i $wslImg"
}

# 5. Export
Write-Host "[5/5] Export docker-linux.tar..."
if (Test-Path $tarFile) { Remove-Item $tarFile -Force }
wsl --export $distroName $tarFile
wsl --unregister $distroName 2>$null | Out-Null
Remove-Item -Recurse -Force $buildDir -ErrorAction SilentlyContinue

$linuxMo = [math]::Round((Get-Item $tarFile).Length / 1MB)
$imgMo = if (Test-Path $imagesTar) { [math]::Round((Get-Item $imagesTar).Length / 1MB) } else { 0 }
Write-Host ""
Write-Host "Termine !"
Write-Host "  docker-linux.tar : $linuxMo Mo"
Write-Host "  images.tar       : $imgMo Mo"
Write-Host "Copiez docker-vm/wsl/ sur votre cle USB."
