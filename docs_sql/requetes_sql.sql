-- Création de la table Joueurs
CREATE TABLE Joueurs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    prenom VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    bourse INT DEFAULT 0, -- DéeVee
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Création de la table Kafes
CREATE TABLE Kafes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    avatar VARCHAR(255),
    gout INT DEFAULT 0,
    amertume INT DEFAULT 0,
    teneur INT DEFAULT 0,
    odorat INT DEFAULT 0,
    rendement_fruit INT DEFAULT 0,
    duree_pousse INT DEFAULT 0
);

-- Création de la table Champs
CREATE TABLE Champs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(255) NOT NULL,
    specialite VARCHAR(255),
    joueur_id INT, 
    FOREIGN KEY (joueur_id) REFERENCES Joueurs(id)
);

-- Création de la table Exploitation (pour lier plusieurs champs à un joueur)
CREATE TABLE Exploitations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    joueur_id INT,
    FOREIGN KEY (joueur_id) REFERENCES Joueurs(id)
);

-- Table de l'assemblage des Kafés
CREATE TABLE Assemblages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    joueur_id INT,
    kafe_id INT,
    quantite INT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (joueur_id) REFERENCES Joueurs(id),
    FOREIGN KEY (kafe_id) REFERENCES Kafes(id)
);

-- Table pour soumettre un Kafé au concours
CREATE TABLE Concours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    joueur_id INT,
    kafe_id INT,
    quantite INT,
    date_soumission TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (joueur_id) REFERENCES Joueurs(id),
    FOREIGN KEY (kafe_id) REFERENCES Kafes(id)
);
