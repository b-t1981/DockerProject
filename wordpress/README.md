# WordPress + MariaDB — Parcours Docker

Ce dossier contient un parcours progressif pour apprendre Docker avec WordPress et MariaDB.

## Démarrage

```bash
cd wordpress
cp .env.example .env   # Windows : copy .env.example .env
docker compose up -d
```

WordPress : http://localhost:8080
phpMyAdmin : http://localhost:8081

## Étapes du parcours

| Version | Notion |
|---------|--------|
| v0.9 | Compose minimal (2 services) |
| v0.10 | Volumes nommés (persistance des données) |
| v0.11 | Variables d'environnement (.env) |
| v0.12 | Healthcheck et dépendances |
| v0.13 | Service phpMyAdmin |
| v0.14 | Dockerfile personnalisé (thème WordPress) |
| v0.15 | Réseaux Docker explicites (`web` + `data`) |

## Thème personnalisé

À partir de v0.14, WordPress est construit à partir d'une image custom qui inclut le thème `docker-learning`. Après le premier démarrage, activez-le dans **Apparence → Thèmes** dans l'admin WordPress.

## v0.15 — Réseaux Docker

Deux réseaux isolent les rôles des services :

| Réseau | Services | Rôle |
|--------|----------|------|
| `web` | wordpress, phpmyadmin | Couche web (accessible depuis votre PC) |
| `data` | db, wordpress, phpmyadmin | Couche base de données (réseau interne) |

MariaDB n'est sur le réseau `data` uniquement : elle n'est pas exposée directement sur Internet.

### Exercices

```bash
# Lister les réseaux créés par Compose
docker network ls

# Inspecter le réseau interne de la base
docker network inspect wordpress_data

# Vérifier que WordPress joint les deux réseaux
docker inspect wordpress-wordpress-1 --format "{{json .NetworkSettings.Networks}}"
```

### Mots de passe et environnements

Les identifiants MariaDB sont définis dans `.env` (fichier local, non versionné).

| Variable | Où la retrouver |
|----------|-----------------|
| `MYSQL_PASSWORD` | `wordpress/.env` |
| `WORDPRESS_DB_*` | Injectées automatiquement dans le conteneur WordPress |

MariaDB crée la base et l'utilisateur **uniquement au premier démarrage** (volume vide). Si vous changez `.env` ensuite, faites `docker compose down -v` en dev pour tout recréer.
