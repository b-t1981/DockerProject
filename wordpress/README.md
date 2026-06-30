# WordPress + MariaDB — Parcours Docker

Ce dossier contient un parcours progressif pour apprendre Docker avec WordPress et MariaDB.

## Démarrage

```bash
cd wordpress
docker compose up -d
```

WordPress : http://localhost:8080

## Étapes du parcours

| Version | Notion |
|---------|--------|
| v0.9 | Compose minimal (2 services) |
| v0.10 | Volumes nommés (persistance) |
| v0.11 | Variables d'environnement (.env) |
| v0.12 | Healthcheck et dépendances |
| v0.13 | Service phpMyAdmin |
| v0.14 | Dockerfile personnalisé |
