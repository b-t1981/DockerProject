# Lance Docker via WSL Linux embarque (sans Docker Desktop)
$ErrorActionPreference = "Stop"
$wslScript = Join-Path $PSScriptRoot "wsl\lancer.ps1"

if (-not (Test-Path (Join-Path $PSScriptRoot "wsl\docker-linux.tar"))) {
    Write-Host ""
    Write-Host "Archive Linux+Docker absente."
    Write-Host "Sur votre PC principal, executez :"
    Write-Host "  cd docker-vm\wsl"
    Write-Host "  .\build-distro.ps1"
    Write-Host ""
    Write-Host "Puis copiez docker-linux.tar sur la cle USB."
    Write-Host ""
    Write-Host "Plan B (sans WSL) : docker-vm\vbox\lancer.ps1"
    exit 1
}

& $wslScript
