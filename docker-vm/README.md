# Docker sur n'importe quel PC — sans Docker Desktop, sans Laragon
#
# Solution : Linux embarque sur la cle USB via WSL2
# Docker tourne DANS Linux (WSL), vos fichiers restent sur la cle.
#
#          ┌─────────────────────────────────────┐
# Clé USB  │  docker-vm/wsl/docker-linux.tar   │  ← Linux + Docker (~2 Go)
#          │  wordpress/data/                  │  ← vos donnees
#          └─────────────────────────────────────┘
#                         │
#                         ▼
#              PC Windows (WSL2, pas Docker Desktop)
#              localhost:8080 → WordPress

## Etape 1 — Construire Linux+Docker (une fois, sur VOTRE PC)

```powershell
cd docker-vm\wsl
.\build-distro.ps1
```

Cree `docker-linux.tar` (~1-2 Go) : Ubuntu + Docker Engine.

## Etape 2 — Sur un autre PC

```powershell
cd docker-vm\wsl
.\install-distro.ps1
.\lancer.ps1
```

Ou double-clic sur **`LANCER.bat`** a la racine du projet.

## Prerequis sur le PC invité

- Windows 10/11 64 bits
- WSL2 active (souvent deja present sur Windows 11)
- Si WSL absent : une fois en admin → `wsl --install` puis redemarrage

> Pas besoin de Docker Desktop. Pas besoin de Laragon. Pas de connexion a votre PC maison.

## Vos donnees

Tout est dans `wordpress/data/` sur la cle USB. Linux accede au projet via `/mnt/c/...` ou lettre USB `/mnt/e/...`.

## Si WSL impossible (PC bloque sans admin)

Utilisez la VM Linux VirtualBox (plan B) :

```powershell
cd docker-vm\vbox
.\install-vbox.ps1
.\create-vm.ps1
.\lancer.ps1
```

## Arreter

```powershell
cd docker-vm\wsl
.\arreter.ps1
```

Sauvegarde les donnees dans `wordpress/data/`.
