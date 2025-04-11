```markdown
# KafeApp

## Description

L'application "KafeApp" permet à un joueur de cultiver des plans de Kafé, de récolter, de sécher, d'assembler et de soumettre ses assemblages au concours CMTM pour devenir le meilleur torréfacteur du monde. Le joueur peut gérer son exploitation, acheter des plans de Kafé, faire sécher les récoltes et participer à des concours pour gagner des DeeVee (monnaie virtuelle) et des Grains d'or.

## Technologies Utilisées

- Flutter 2.0 ou supérieur
- Firebase pour l'authentification et la gestion des données
- Firebase Firestore pour la base de données en temps réel
- Firebase Storage pour le stockage des avatars
- Firebase Cloud Functions (optionnel pour les notifications)

## Pré-requis

- **Flutter SDK** : Assurez-vous que Flutter est installé sur votre machine. Vous pouvez l'installer via [le site officiel de Flutter](https://flutter.dev/docs/get-started/install).
- **Compte Firebase** : Vous devez avoir un projet Firebase configuré. Si vous n'avez pas encore de projet, vous pouvez créer un projet sur [Firebase Console](https://console.firebase.google.com/).
- **Dépendances Firebase** : Firebase doit être intégré à votre projet Flutter. Assurez-vous que vous avez ajouté `firebase_core`, `firebase_auth`, `cloud_firestore` et d'autres dépendances Firebase dans votre `pubspec.yaml`.

## Installation

### Étape 1 : Cloner le projet

```bash
git clone https://github.com/Heisenberg-2002/kafeApp.git
cd kafeApp

```

### Étape 2 : Installer les dépendances

Assurez-vous que vous avez installé Flutter et que vous êtes dans le répertoire du projet, puis exécutez la commande suivante :

```bash
flutter pub get
```

### Étape 3 : Configurer Firebase

1. Allez sur la console Firebase : [Firebase Console](https://console.firebase.google.com/).
2. Créez un nouveau projet ou utilisez un projet existant.
3. Ajoutez l'application Flutter à votre projet Firebase :
   - Pour iOS : [Ajouter une application iOS](https://firebase.google.com/docs/flutter/setup?platform=ios)
   - Pour Android : [Ajouter une application Android](https://firebase.google.com/docs/flutter/setup?platform=android)
4. Téléchargez le fichier `google-services.json` pour Android ou `GoogleService-Info.plist` pour iOS et placez-le dans le dossier approprié (`android/app` ou `ios/Runner`).
5. Activez Firestore dans votre console Firebase.

### Étape 4 : Configurer Firebase Authentication

1. Allez dans la console Firebase, puis dans "Authentication".
2. Activez les méthodes de connexion souhaitées (email/mot de passe, Google, etc.).

### Étape 5 : Exécuter l'application

Une fois que toutes les dépendances sont installées et Firebase configuré, exécutez l'application avec la commande suivante :

```bash
flutter run
```

L'application devrait démarrer et vous pourrez voir l'écran de connexion (si vous avez configuré l'authentification). Vous pouvez commencer à jouer en créant un compte ou en vous connectant à un compte existant.

## Fonctionnalités principales

1. **Plantage** : Le joueur peut planter des plans de Kafé dans son champ. Chaque type de Kafé a des caractéristiques différentes.
2. **Récolte** : Une fois que le plan a poussé, il peut être récolté pour obtenir des fruits de Kafé.
3. **Séchage** : Les fruits récoltés doivent être séchés avant de pouvoir être utilisés pour un assemblage.
4. **Assemblage** : Le joueur peut assembler différents types de Kafé pour créer des assemblages. Chaque assemblage peut être soumis au concours CMTM.
5. **Concours CMTM** : Les assemblages sont soumis au concours pour tenter de gagner des DeeVee et des Grains d'or.

## Fonctionnalités à venir

1. **Notifications locales** pour informer l'utilisateur si son assemblage a gagné le concours.
2. **Cloud Functions** pour gérer les concours automatiquement toutes les 15 minutes.

## Structure du projet

```
lib/
  |-- services/                # Services pour gérer les interactions avec Firebase
  |-- models/                  # Modèles de données pour Kafé et autres entités
  |-- screens/                 # Écrans principaux (SéchagePage, AssemblagePage, etc.)
  |-- main.dart                # Point d'entrée de l'application
  |-- utils/                   # Fonctions utilitaires
```

## Problèmes connus

1. **Problème de mise à jour des kafés dans la page de séchage** : Assurez-vous que la quantité de Kafé est bien mise à jour dans Firestore après chaque assemblage.
2. **Concours CMTM** : Le concours se déroule toutes les 15 minutes et l'intégration des règles du concours peut nécessiter des ajustements côté serveur.

## Contact

Pour toute question ou problème, vous pouvez me contacter à **votre.email@exemple.com**.
```

---

Vous pouvez maintenant copier le contenu ci-dessus dans votre fichier `README.md` de votre projet. Une fois que vous avez collé le contenu dans VS Code, vous serez prêt à partager les instructions avec d'autres développeurs ou utilisateurs de votre application.