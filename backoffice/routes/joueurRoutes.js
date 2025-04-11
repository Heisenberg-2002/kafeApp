const express = require('express');
const router = express.Router();
const joueurController = require('../controllers/joueurController');

router.post('/', joueurController.createJoueur);  // Route pour créer un joueur
router.get('/', joueurController.getJoueurs);     // Route pour récupérer tous les joueurs

module.exports = router;
