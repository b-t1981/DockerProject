# Docker sans installation — mode distant

Sur un PC **sans Docker Desktop**, vous pouvez quand même utiliser Docker en ne gardant que le **client** (`docker.exe`, ~60 Mo) et en pilotant un moteur Docker **à distance** (votre PC maison ou un serveur cloud).

```
PC invité (sans Docker)          PC maison / serveur cloud
┌─────────────────────┐          ┌─────────────────────┐
│  docker.exe (USB)   │  SSH     │  Docker Engine      │
│  docker compose up  │ ──────►  │  vos conteneurs     │
└─────────────────────┘          └─────────────────────┘
         │                                    │
         └──────── http://IP-maison:8080 ─────┘
                    (accès au site)
```

## Prérequis (une seule fois)

### Sur la machine qui fait tourner Docker (chez vous)

1. Docker Desktop **ou** Docker Engine doit tourner en permanence
2. SSH activé — script fourni :
   ```powershell
   # PowerShell en administrateur
   cd portable
   .\activer-ssh.ps1
   ```
3. Votre utilisateur Windows doit pouvoir se connecter en SSH

### Sur le PC invité (sans Docker installé)

1. Installez le client portable :
   ```powershell
   cd portable
   .\install.ps1
   ```
   (ou utilisez `bin\docker.exe` déjà présent sur la clé USB)
2. OpenSSH client (déjà présent sur Windows 10/11)

## Démarrage rapide (même PC avec Docker Desktop)

Double-clic sur **`LANCER.bat`** ou :

```powershell
cd portable
.\lancer-wordpress.ps1
```

## Préparer une clé USB

```powershell
cd portable
.\pack-usb.ps1 -DriveLetter "E"
```

Copie tout le projet + `docker.exe` + `wordpress/data/` sur la clé.

## Configuration rapide

```powershell
cd portable
.\setup-remote.ps1 -HostName "192.168.1.50" -UserName "VOTRE_USER"
```

Remplacez `192.168.1.50` par l'IP de votre PC maison (ou nom Tailscale).

Puis lancez WordPress **sur la machine distante** depuis le PC invité :

```powershell
.\docker-remote.ps1 compose -f ..\wordpress\docker-compose.yml up -d
```

## Accéder au site

| Où tourne Docker | URL depuis le PC invité |
|------------------|-------------------------|
| PC maison (même réseau WiFi) | http://IP-maison:8080 |
| PC maison (autre lieu) | VPN Tailscale ou Cloudflare Tunnel |
| Serveur cloud | http://IP-serveur:8080 |

## Option cloud (PC maison éteint)

Créez une petite VM gratuite (Oracle Cloud, Hetzner, etc.) avec Docker :

```bash
# Sur le serveur Linux
curl -fsSL https://get.docker.com | sh
```

Puis utilisez la même config SSH avec l'IP du serveur.

## Ce qu'on embarque sur la clé USB

```
portable/
├── bin/docker.exe       ← client seul (~60 Mo)
├── setup-remote.ps1     ← configuration SSH
├── docker-remote.ps1    ← lance docker vers la machine distante
└── README.md
```

+ le dossier `wordpress/data/` pour vos fichiers (sync séparée ou rsync).

## Limites

| Approche | Docker local sans install | Site accessible hors réseau |
|----------|---------------------------|-------------------------------|
| Client distant + PC maison | ✅ | ⚠️ VPN ou tunnel requis |
| Client distant + cloud | ✅ | ✅ |
| Boot Linux sur clé USB | ✅ (autre méthode) | ✅ sur la clé |

## Alternative : Linux bootable sur clé USB

Sans rien installer sur Windows : démarrez le PC depuis une clé USB Linux (Ventoy + Ubuntu) avec Docker préinstallé. Plus lourd, mais Docker tourne **localement** sur la clé.
