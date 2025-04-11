# Documentation du Projet

## Base de données

La base de données pour ce projet est conçue pour gérer les joueurs, leurs Kafés, champs et exploitations, ainsi que les assemblages de Kafés pour le concours.

### Requêtes SQL

Les requêtes SQL suivantes sont utilisées pour créer les tables de la base de données. Elles sont stockées dans le fichier [docs/requetes_sql.sql](docs/requetes_sql.sql).

#### Tables Créées :
- **Joueurs** : pour enregistrer les informations des utilisateurs.
- **Kafes** : pour définir les différents types de Kafés avec leurs attributs.
- **Champs** : pour gérer les champs cultivés par les joueurs.
- **Exploitation** : pour lier un ou plusieurs champs à un joueur.
- **Assemblages** : pour gérer les assemblages de Kafés par les joueurs.
- **Concours** : pour soumettre un assemblage au concours.

Les requêtes SQL permettent de définir la structure de la base de données utilisée pour la gestion des différentes entités du jeu.
