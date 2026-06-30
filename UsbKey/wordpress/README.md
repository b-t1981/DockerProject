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
| v0.16 | Données portables dans `data/` (emportable partout) |

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

MariaDB crée la base et l'utilisateur **uniquement au premier démarrage** (dossier `data/db` vide). Si vous changez `.env` ensuite, supprimez `data/db` en dev pour tout recréer.

## v0.16 — Site portable (tout embarquer)

Les données sont dans le dossier du projet, plus dans des volumes Docker cachés :

```
wordpress/data/
├── db/          → base MariaDB
└── wordpress/   → fichiers du site
```

### Travailler chez vous, chez un ami, etc.

1. Travaillez normalement sur WordPress
2. Copiez **tout le dossier** `DockerProject` (avec `wordpress/data/` et `wordpress/.env`)
3. Sur l'autre PC : `docker compose up -d`
4. Votre site continue **avec les mêmes articles et comptes**

| À emporter | Obligatoire |
|------------|-------------|
| `wordpress/data/` | Oui — c'est votre site |
| `wordpress/.env` | Oui — mêmes mots de passe DB |
| Le reste du code | Oui (ou `git clone` + recopier `data/`) |

### Sauvegarde de sécurité (optionnel)

```powershell
cd wordpress
.\scripts\backup.ps1
```

Crée un dossier `backups/AAAA-MM-JJ-HHMMSS/` avec la base + les fichiers.

Restauration :

```powershell
.\scripts\restore.ps1 -BackupDir "backups\20260630-120000"
```
