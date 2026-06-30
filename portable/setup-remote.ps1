# Configure Docker pour piloter une machine distante via SSH
# Usage : .\setup-remote.ps1 -HostName "192.168.1.50" -UserName "monuser"

param(
    [Parameter(Mandatory = $true)]
    [string]$HostName,

    [Parameter(Mandatory = $true)]
    [string]$UserName,

    [int]$Port = 22,
    [string]$ContextName = "maison"
)

$ErrorActionPreference = "Stop"
$bin = Join-Path $PSScriptRoot "bin"
$docker = Join-Path $bin "docker.exe"

if (-not (Test-Path $docker)) {
    Write-Host ""
    Write-Host "docker.exe introuvable dans portable\bin\"
    Write-Host "Telechargez : https://download.docker.com/win/static/stable/x86_64/"
    Write-Host "Extrayez docker.exe dans : $bin"
    Write-Host ""
    New-Item -ItemType Directory -Force -Path $bin | Out-Null
    exit 1
}

$endpoint = "ssh://${UserName}@${HostName}:${Port}"
& $docker context create $ContextName --docker "host=$endpoint" 2>$null
& $docker context use $ContextName

Write-Host ""
Write-Host "Contexte Docker actif : $ContextName"
Write-Host "Machine distante       : $endpoint"
Write-Host ""
Write-Host "Test : .\docker-remote.ps1 ps"
Write-Host "Lancer WordPress : .\docker-remote.ps1 compose -f ..\wordpress\docker-compose.yml up -d"
