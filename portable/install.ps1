# Installe le client Docker portable (docker.exe) si absent
# Usage : .\install.ps1

$ErrorActionPreference = "Stop"
$bin = Join-Path $PSScriptRoot "bin"
$docker = Join-Path $bin "docker.exe"

New-Item -ItemType Directory -Force -Path $bin | Out-Null

if (Test-Path $docker) {
    Write-Host "docker.exe deja present : $docker"
    & $docker --version
    exit 0
}

$version = "29.5.3"
$url = "https://download.docker.com/win/static/stable/x86_64/docker-$version.zip"
$zip = Join-Path $env:TEMP "docker-client.zip"
$extract = Join-Path $env:TEMP "docker-extract"

Write-Host "Telechargement du client Docker $version..."
curl.exe -L -o $zip $url
if (-not (Test-Path $zip)) { Write-Error "Echec du telechargement" }

Remove-Item -Recurse -Force $extract -ErrorAction SilentlyContinue
Expand-Archive -Path $zip -DestinationPath $extract -Force
Copy-Item (Join-Path $extract "docker\docker.exe") $docker -Force
Remove-Item $zip -Force

Write-Host "Installation terminee :"
& $docker --version
