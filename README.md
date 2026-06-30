# DockerProject

Projet d'apprentissage Docker organisé en parcours progressifs.

## Chapitre 1 — Application custom (v0.1 → v0.8)

Stack Flask + PostgreSQL à la racine du projet.

```bash
copy .env.example .env
docker compose up --build
```

Application : http://localhost:8080

## Chapitre 2 — WordPress + MariaDB (v0.9 → v0.14)

Parcours dans le dossier `wordpress/` : compose, volumes, variables d'environnement, healthcheck, phpMyAdmin et Dockerfile personnalisé.

```bash
cd wordpress
copy .env.example .env
docker compose up --build -d
```

- WordPress : http://localhost:8080
- phpMyAdmin : http://localhost:8081

Consultez [wordpress/README.md](wordpress/README.md) pour le détail de chaque étape.
