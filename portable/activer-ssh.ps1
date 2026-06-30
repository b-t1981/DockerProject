# Active OpenSSH Server sur Windows (necessite droits admin)
# Permet au PC invité de piloter Docker sur cette machine

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "Relancez PowerShell en tant qu'administrateur pour activer SSH."
    Write-Host "Clic droit sur PowerShell -> Executer en tant qu'administrateur"
    exit 1
}

$cap = Get-WindowsCapability -Online | Where-Object Name -like "OpenSSH.Server*"
if ($cap.State -ne "Installed") {
    Write-Host "Installation OpenSSH Server..."
    Add-WindowsCapability -Online -Name $cap.Name
}

Start-Service sshd -ErrorAction SilentlyContinue
Set-Service -Name sshd -StartupType Automatic

$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.InterfaceAlias -notmatch "Loopback" -and $_.IPAddress -notmatch "^169" } | Select-Object -First 1).IPAddress
$user = $env:USERNAME

Write-Host ""
Write-Host "SSH actif sur ce PC."
Write-Host "IP locale : $ip"
Write-Host "Utilisateur : $user"
Write-Host ""
Write-Host "Sur le PC invité :"
Write-Host "  cd portable"
Write-Host "  .\setup-remote.ps1 -HostName `"$ip`" -UserName `"$user`""
