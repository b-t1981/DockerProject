# Cree la VM Linux VirtualBox avec Docker
# Usage : .\create-vm.ps1

$ErrorActionPreference = "Stop"
$vmName = "DockerProject-VM"
$vmDir = Join-Path $PSScriptRoot "vm"
$diskPath = Join-Path $vmDir "disk.vdi"
$isoUrl = "https://releases.ubuntu.com/24.04.3/ubuntu-24.04.3-live-server-amd64.iso"
$isoPath = Join-Path $vmDir "ubuntu.iso"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

$vbox = "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe"
if (-not (Test-Path $vbox)) {
    Write-Host "Installez VirtualBox d'abord : https://www.virtualbox.org/"
    exit 1
}

New-Item -ItemType Directory -Force -Path $vmDir | Out-Null

if (-not (Test-Path $isoPath)) {
    Write-Host "Telechargement Ubuntu Server ISO (~2 Go)..."
    curl.exe -L -o $isoPath $isoUrl
}

& $vbox list vms | Select-String $vmName | Out-Null
if ($LASTEXITCODE -eq 0) {
    Write-Host "VM deja existante."
    exit 0
}

Write-Host "Creation VM $vmName ..."
& $vbox createvm --name $vmName --register --basefolder $vmDir
& $vbox modifyvm $vmName --ostype Ubuntu_64 --memory 4096 --cpus 2 --nic1 nat
& $vbox modifyvm $vmName --natpf1 "ssh,tcp,,2222,,22"
& $vbox modifyvm $vmName --natpf1 "wp,tcp,,8080,,8080"
& $vbox modifyvm $vmName --natpf1 "pma,tcp,,8081,,8081"
& $vbox createmedium disk --filename $diskPath --size 20480 --format VDI
& $vbox storagectl $vmName --name SATA --add sata --controller IntelAhci
& $vbox storageattach $vmName --storagectl SATA --port 0 --device 0 --type hdd --medium $diskPath
& $vbox storageattach $vmName --storagectl SATA --port 1 --device 0 --type dvddrive --medium $isoPath
& $vbox sharedfolder add $vmName --name project --hostpath $projectRoot --automount

Write-Host ""
Write-Host "VM creee. Installez Ubuntu manuellement (une fois) :"
Write-Host "  1. VirtualBox -> Demarrer $vmName"
Write-Host "  2. Installer Ubuntu Server"
Write-Host "  3. Creer utilisateur 'docker' / mot de passe 'docker'"
Write-Host "  4. Dans la VM : curl -fsSL https://get.docker.com | sh"
Write-Host "  5. sudo usermod -aG docker docker"
Write-Host ""
Write-Host "Ensuite : .\lancer.ps1"
