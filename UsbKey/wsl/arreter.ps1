# Arrete WordPress et sauvegarde les donnees sur la cle
$distroName = "DockerProject"
$usbRoot = Split-Path -Parent $PSScriptRoot
$wpDir = Join-Path $usbRoot "wordpress"

function Win-ToWsl($path) {
    $p = $path -replace '\\', '/'
    if ($p -match '^([A-Za-z]):(.*)') { return "/mnt/$($matches[1].ToLower())$($matches[2])" }
    return $p
}

$wslWp = Win-ToWsl $wpDir
"cd '$wslWp' && docker compose down 2>/dev/null; exit 0" | wsl -d $distroName -u root -e bash 2>$null

Write-Host "WordPress arrete."
Write-Host "Donnees conservees dans : $wpDir\data\"
