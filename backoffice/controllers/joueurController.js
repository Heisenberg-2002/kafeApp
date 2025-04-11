const Joueur = require('../models/joueur');  // Modèle de joueur

// Création d'un joueur
exports.createJoueur = async (req, res) => {
  const { nom, prenom, email, bourse } = req.body;
  const joueur = new Joueur({ nom, prenom, email, bourse });

  try {
    const savedJoueur = await joueur.save();
    res.status(201).json(savedJoueur);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Récupérer tous les joueurs
exports.getJoueurs = async (req, res) => {
  try {
    const joueurs = await Joueur.find();
    res.status(200).json(joueurs);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
