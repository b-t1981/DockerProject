# WordPress sans Docker — 100 % local sur la clé USB

Sur un PC **sans Docker**, WordPress + MariaDB tournent **directement sur le PC invité** via **Laragon Portable** (PHP + MariaDB embarqués). Aucune connexion à votre PC maison.

```
Clé USB
├── sans-docker/laragon/     ← PHP + MariaDB + Apache (~200 Mo)
├── wordpress/data/          ← vos données (fichiers + export SQL)
└── LANCER.bat               ← détecte Docker ou Lance Laragon
```

## Installation (une seule fois)

### 1. Télécharger Laragon Portable

https://laragon.org/download/

Choisissez **Laragon Portable** (fichier `.7z` ou `.zip`).

### 2. Extraire dans ce dossier

```
sans-docker/laragon/laragon.exe
```

### 3. Installer automatiquement (tente le téléchargement)

```powershell
cd sans-docker
.\install-laragon.ps1
```

## Lancer WordPress

Double-clic sur **`LANCER.bat`** à la racine du projet.

Ou :

```powershell
cd sans-docker
.\lancer.ps1
```

→ http://localhost/wordpress

## Vos données suivent

| Fichier / dossier | Contenu |
|-------------------|---------|
| `wordpress/data/wordpress/` | Fichiers du site |
| `wordpress/data/backup/site.sql` | Export de la base (mis à jour automatiquement) |

Avant de quitter un PC, le script **sauvegarde** la base dans `site.sql`.
Au démarrage sur un autre PC, il **restaure** `site.sql` → même site, mêmes articles.

## Docker vs sans Docker

| Mode | Quand | Commande |
|------|-------|----------|
| **Docker** | Docker Desktop installé | `portable\LANCER.bat` |
| **Sans Docker** | PC invité, clé USB | `LANCER.bat` (racine) ou `sans-docker\LANCER.bat` |

Les deux modes utilisent le **même** dossier `wordpress/data/`.

## Préparer la clé USB

```powershell
cd portable
.\pack-usb.ps1 -DriveLetter "E"
```

Puis extrayez Laragon dans `E:\DockerProject\sans-docker\laragon\`.
