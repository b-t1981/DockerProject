# DockerProject

Projet d'apprentissage Docker organisé en parcours progressifs.

## Chapitre 1 — Application custom (v0.1 → v0.8)

Stack Flask + PostgreSQL à la racine du projet.

```bash
copy .env.example .env
docker compose up --build
```

Application : http://localhost:8080

## Lancer WordPress (Docker ou rien)

Double-clic sur **`LANCER.bat`** :

| Priorite | Mode | Condition |
|----------|------|-----------|
| 1 | Docker Desktop | Deja installe sur le PC |
| 2 | **Linux WSL embarque** | `docker-linux.tar` sur la cle USB |
| 3 | VM Linux VirtualBox | Plan B si WSL impossible |

Vos donnees : `wordpress/data/` (sur la cle USB).

Guide : [docker-vm/README.md](docker-vm/README.md)

## Cle USB autonome (sans Docker Desktop)

Dossier **`UsbKey/`** — tout-en-un pour PC sans Docker :

```powershell
cd UsbKey
.\prepare-usbkey.ps1
```

Puis copiez `UsbKey\` sur la cle USB. Sur le PC invite : double-clic **`LANCER.bat`**.

Guide : [UsbKey/README.md](UsbKey/README.md)

## Chapitre 2 — WordPress + MariaDB (v0.9 → v0.21)

Parcours dans le dossier `wordpress/` : compose, volumes, variables d'environnement, healthcheck, phpMyAdmin et Dockerfile personnalisé.

```bash
cd wordpress
copy .env.example .env
docker compose up --build -d
```

- WordPress : http://localhost:8080
- phpMyAdmin : http://localhost:8081

Consultez [wordpress/README.md](wordpress/README.md) pour le détail de chaque étape.
