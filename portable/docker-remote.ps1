# Lance docker.exe (client portable) vers la machine distante configuree
# Usage : .\docker-remote.ps1 compose -f ..\wordpress\docker-compose.yml up -d

$docker = Join-Path $PSScriptRoot "bin\docker.exe"

if (-not (Test-Path $docker)) {
    Write-Error "docker.exe manquant. Voir portable\README.md"
}

& $docker @args
