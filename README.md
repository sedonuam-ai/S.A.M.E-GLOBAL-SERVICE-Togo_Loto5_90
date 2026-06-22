# Loto Togo - Application Android

Application mobile regroupant les 12 jeux de Loto 5/90 du Togo en une seule app,
avec saisie manuelle des résultats, historique par jeu, **fonctionnement 100% hors-ligne**,
et **installation via GitHub** sans passer par le Play Store.

## Fonctionnement hors-connexion

L'application stocke tous les résultats directement sur le téléphone (mémoire locale),
sans avoir besoin d'internet. Tu peux donc consulter les résultats et en saisir de
nouveaux même sans connexion. (Seule l'installation initiale depuis GitHub nécessite
internet, comme pour télécharger n'importe quelle application.)

## Les 12 jeux intégrés

| Jour      | 13:00          | 18:00          |
|-----------|----------------|----------------|
| Lundi     | Lotto Diamant  | Loto Gold      |
| Mardi     | Loto Cash      | Loto Boom      |
| Mercredi  | Loto Benz      | Loto Prestige  |
| Jeudi     | Loto Million   | Loto Super     |
| Vendredi  | Loto Kadoo     | Loto King      |
| Samedi    | Loto Sam       | Loto Bingo     |

## Mettre le projet sur GitHub (à faire une seule fois)

1. Crée un compte sur https://github.com si tu n'en as pas.
2. Crée un nouveau dépôt (bouton vert "New repository"), nomme-le par exemple
   `loto-togo-app`, et laisse-le **public** (pour que les gens puissent
   télécharger l'APK librement) ou **privé** si tu veux le garder fermé.
3. Sur ton ordinateur, dans le dossier du projet décompressé, lance :
   ```
   git init
   git add .
   git commit -m "Première version de l'application Loto Togo"
   git branch -M main
   git remote add origin https://github.com/TON_NOM_UTILISATEUR/loto-togo-app.git
   git push -u origin main
   ```
4. Va dans l'onglet **Actions** de ton dépôt GitHub : une compilation va se
   lancer automatiquement (le fichier `.github/workflows/build.yml` s'en
   occupe). Elle prend quelques minutes.
5. Une fois terminée, va dans l'onglet **Releases** (à droite de la page du
   dépôt) : tu y trouveras un fichier **.apk** prêt à télécharger.

À chaque fois que tu modifies le code et que tu fais `git push`, une nouvelle
Release avec un nouvel APK sera générée automatiquement.

## Comment les utilisateurs installent l'application depuis GitHub

1. Aller sur la page du dépôt GitHub, cliquer sur **Releases**.
2. Télécharger le fichier `app-release.apk` le plus récent.
3. Sur le téléphone Android, ouvrir le fichier téléchargé.
4. Si Android bloque l'installation ("source inconnue"), aller dans
   **Paramètres > Sécurité > Autoriser l'installation d'applications
   inconnues** pour le navigateur ou l'application utilisée pour télécharger.
5. Confirmer l'installation : l'icône "LT 5/90" apparaît sur l'écran d'accueil.

## Travailler sur le projet en local (avant de publier sur GitHub)

### 1. Installer Flutter
https://docs.flutter.dev/get-started/install — puis vérifier avec :
```
flutter doctor
```

### 2. Initialiser le projet Flutter complet
Comme ce dossier contient le code source et la config (pas tous les fichiers
Android générés), lance dans le dossier parent :
```
flutter create loto_togo_app
```
Puis copie `lib/`, `assets/`, `pubspec.yaml`, et `.github/` de ce projet dans
le nouveau dossier `loto_togo_app/` en remplaçant les fichiers existants.

### 3. Installer les dépendances et générer l'icône
```
flutter pub get
flutter pub run flutter_launcher_icons
```

### 4. Tester sur ton téléphone (branché en USB, mode débogage activé)
```
flutter run
```

### 5. Générer l'APK manuellement (sans passer par GitHub Actions)
```
flutter build apk --release
```
Fichier généré : `build/app/outputs/flutter-apk/app-release.apk`

## Le logo

Le logo "LT 5/90" se trouve dans `assets/icon/icon.png`. Pour le changer,
remplace simplement ce fichier par ta propre image carrée (1024x1024px de
préférence), puis relance :
```
flutter pub run flutter_launcher_icons
```

## Comment utiliser l'application

1. **Écran d'accueil** : les 12 jeux groupés par jour, avec le dernier
   résultat connu pour chacun.
2. **Bouton crayon (en haut à droite)** : ouvre l'écran de saisie. Choisis
   le jeu, la date, entre les 5 numéros gagnants, puis valide.
3. **Toucher un jeu** dans la liste : affiche l'historique complet des
   résultats enregistrés pour ce jeu.

## Prochaines améliorations possibles

- Ajouter une protection par mot de passe sur l'écran de saisie
- Synchroniser les résultats sur Firebase pour que plusieurs personnes
  voient les mêmes résultats en temps réel (en plus du mode hors-ligne)
- Ajouter des notifications à l'heure de chaque tirage
- Permettre aux utilisateurs d'enregistrer leurs propres grilles jouées
  et de vérifier automatiquement s'ils ont gagné
