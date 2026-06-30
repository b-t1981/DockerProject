# DockerProject

Projet d'apprentissage Docker organisé en parcours progressifs.

## Chapitre 1 — Application custom (v0.1 → v0.8)

Stack Flask + PostgreSQL à la racine du projet.

```bash
copy .env.example .env
docker compose up --build
```

Application : http://localhost:8080

## Lancer WordPress (n'importe quel PC)

Double-clic sur **`LANCER.bat`** a la racine :

| PC | Mode utilise |
|----|--------------|
| Docker Desktop installe | Docker (WordPress + MariaDB en conteneurs) |
| Sans Docker | Laragon Portable (PHP + MariaDB sur la cle USB) |

Vos donnees suivent dans `wordpress/data/`.

- Docker : http://localhost:8080
- Sans Docker : http://localhost/wordpress

Guide sans Docker : [sans-docker/README.md](sans-docker/README.md)

## Chapitre 2 — WordPress + MariaDB (v0.9 → v0.20)

Parcours dans le dossier `wordpress/` : compose, volumes, variables d'environnement, healthcheck, phpMyAdmin et Dockerfile personnalisé.

```bash
cd wordpress
copy .env.example .env
docker compose up --build -d
```

- WordPress : http://localhost:8080
- phpMyAdmin : http://localhost:8081

Consultez [wordpress/README.md](wordpress/README.md) pour le détail de chaque étape.
