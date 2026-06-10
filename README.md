# NetInfo CPAM — Compilation via GitHub Actions

## Structure du repo GitHub

```
votre-repo/
├── .github/
│   └── workflows/
│       └── build.yml       ← workflow de compilation
├── netinfo_cpam.ps1
├── NetInfo_Light.ps1
└── README.md
```

## Etapes

### 1. Creer le repo GitHub
- Allez sur https://github.com/new
- Nom : `netinfo-cpam` (privé de préférence)
- Cliquez "Create repository"

### 2. Uploader les fichiers
Depuis la page du repo, cliquez "uploading an existing file" et deposez :
- `netinfo_cpam.ps1`
- `NetInfo_Light.ps1`
- Le dossier `.github/workflows/build.yml`
  (creer le dossier manuellement : "Create new file" -> taper `.github/workflows/build.yml`)

### 3. Lancer la compilation
- Onglet "Actions" dans votre repo
- Cliquez "Build NetInfo EXE" dans la liste a gauche
- Bouton "Run workflow" -> "Run workflow"
- Attendez ~2 minutes

### 4. Telecharger les exe
- Cliquez sur le workflow termine (coche verte)
- Section "Artifacts" en bas de page
- Cliquez "NetInfo-EXE" pour telecharger le ZIP
- Dezippez -> vous avez vos deux .exe !

## Notes
- Le repo peut etre en "Private" pour ne pas exposer le code
- Les artefacts sont conserves 7 jours
- Gratuit sur GitHub (2000 minutes/mois incluses)
