# Client Docker portable (si Docker Desktop est installe)

Utilisez ce dossier **uniquement si Docker Desktop est disponible** sur le PC.

> **PC sans Docker ?** Utilisez `sans-docker\` ou le `LANCER.bat` a la racine (detecte automatiquement).

## Demarrage rapide

Double-clic sur **`LANCER.bat`** ou :

```powershell
cd portable
.\lancer-wordpress.ps1
```

WordPress : http://localhost:8080

## Installer docker.exe (optionnel)

Si `docker` n'est pas dans le PATH mais Docker Desktop est installe :

```powershell
.\install.ps1
```

## Arreter (garde les donnees)

```powershell
.\arreter-wordpress.ps1
```

Sauvegarde aussi `wordpress\data\backup\site.sql` pour le mode sans Docker.

## Preparer une cle USB

```powershell
.\pack-usb.ps1 -DriveLetter "E"
```

Puis installez Laragon Portable dans `E:\DockerProject\sans-docker\laragon\` pour les PC sans Docker.
