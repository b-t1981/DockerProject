# WordPress + MariaDB sur cle USB (sans Docker Desktop)
# Linux WSL + Docker embarques — fonctionne hors ligne

## Demarrage (PC sans Docker)

1. Brancher la cle USB
2. Double-clic **`LANCER.bat`**
3. Ouvrir http://localhost:8080

Premier lancement : import Linux (~2 min). Suivants : ~30 sec.

## Arret avant de retirer la cle

Double-clic **`ARRETER.bat`**

## Nettoyer le PC apres demo (optionnel)

Double-clic **`NETTOYER-PC.bat`** — supprime la trace WSL sur le PC invite.

## Contenu de la cle

```
UsbKey/
├── LANCER.bat
├── ARRETER.bat
├── NETTOYER-PC.bat
├── wsl/
│   ├── docker-linux.tar    (~4 Go) Linux + Docker + images
│   └── images.tar          (~640 Mo) sauvegarde images
└── wordpress/
    ├── docker-compose.yml
    ├── .env.example
    ├── custom/
    └── data/               VOS DONNEES (site + base)
```

## Prerequis PC invite

- Windows 10/11 64 bits
- WSL2 active (`wsl --version`)
- Pas besoin de Docker Desktop
- Pas besoin d'Internet (apres preparation de la cle)
- Admin : seulement si WSL pas encore installe (`wsl --install` une fois)

## Regenerer UsbKey depuis le projet principal

Sur votre PC (avec Internet) :

```powershell
cd ..
.\UsbKey\prepare-usbkey.ps1
```
