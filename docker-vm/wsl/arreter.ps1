# Arrete WordPress dans WSL Linux
$distroName = "DockerProject"
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path

function Win-ToWsl($path) {
    $p = $path -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)') { return "/mnt/$($matches[1].ToLower())$($matches[2])" }
    return $p
}

$wslWp = Win-ToWsl (Join-Path $projectRoot "wordpress")
$cmd = "cd '$wslWp' && docker compose down 2>/dev/null; exit 0"

$existing = wsl -l -q 2>$null | Where-Object { $_ -match $distroName }
if ($existing) {
    $cmd | wsl -d $distroName -e bash
}

Write-Host "WordPress arrete. Donnees dans wordpress\data\"
