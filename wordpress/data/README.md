# Données du site (portable)

Ce dossier contient **tout votre site WordPress** :

```
data/
├── db/          → base MariaDB (articles, utilisateurs, réglages)
└── wordpress/   → fichiers WordPress (uploads, plugins, config)
```

## Emportez tout chez vous ou ailleurs

Copiez le dossier `DockerProject` **avec** `wordpress/data/` et `wordpress/.env` :

- Clé USB
- OneDrive / Google Drive
- Zip du projet

Sur l'autre machine :

```powershell
cd DockerProject\wordpress
docker compose up -d
```

Votre site reprend **exactement** où vous l'avez laissé.

> Ne poussez pas `data/` sur GitHub (données personnelles). Utilisez une clé USB ou un cloud privé.
