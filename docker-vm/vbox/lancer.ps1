# Plan B : VM Linux VirtualBox avec Docker (si WSL impossible)
# Usage : .\lancer.ps1

$ErrorActionPreference = "Stop"
$vmName = "DockerProject-VM"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

function Find-VBox {
    $paths = @(
        "${env:ProgramFiles}\Oracle\VirtualBox\VBoxManage.exe",
        "${env:ProgramFiles(x86)}\Oracle\VirtualBox\VBoxManage.exe",
        (Join-Path $PSScriptRoot "tools\VirtualBox\VBoxManage.exe")
    )
    foreach ($p in $paths) { if (Test-Path $p) { return $p } }
    return $null
}

$vbox = Find-VBox
if (-not $vbox) {
    Write-Host "VirtualBox introuvable."
    Write-Host "Installez-le : https://www.virtualbox.org/wiki/Downloads"
    Write-Host "Ou executez : .\install-vbox.ps1"
    exit 1
}

$vmExists = & $vbox list vms | Select-String $vmName
if (-not $vmExists) {
    Write-Host "VM absente. Executez : .\create-vm.ps1"
    exit 1
}

Write-Host "Demarrage VM Linux..."
& $vbox startvm $vmName --type headless

Write-Host "Attente SSH (port 2222)..."
$ready = $false
for ($i = 0; $i -lt 60; $i++) {
    $tcp = New-Object System.Net.Sockets.TcpClient
    try {
        $tcp.Connect("127.0.0.1", 2222)
        $ready = $true
        $tcp.Close()
        break
    } catch { Start-Sleep -Seconds 3 }
}

if (-not $ready) {
    Write-Host "VM demarree mais SSH non disponible. Verifiez la VM."
    exit 1
}

# Chemin partage dans la VM
$winPath = $projectRoot -replace '\\', '/' -replace '^([A-Za-z]):', '/mnt/$1'
$winPath = $projectRoot -replace '\\', '/'
if ($winPath -match '^([A-Za-z]):') {
    $winPath = "/mnt/$($matches[1].ToLower())" + ($projectRoot -replace '^[A-Za-z]:', '' -replace '\\', '/')
}

$sshCmd = @"
cd '$winPath/wordpress' && cp -n .env.example .env 2>/dev/null; docker compose up --build -d
"@

Write-Host "Lancement WordPress dans la VM..."
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=NUL -p 2222 docker@127.0.0.1 $sshCmd

Write-Host ""
Write-Host "WordPress : http://localhost:8080"
Start-Process "http://localhost:8080"
