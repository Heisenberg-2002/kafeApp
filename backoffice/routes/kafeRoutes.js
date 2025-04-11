// /backoffice/routes/kafeRoutes.js
const express = require('express');
const router = express.Router();
const kafeController = require('../controllers/kafeController');

// Route pour créer un Kafé
router.post('/', kafeController.createKafe);

// Route pour obtenir tous les Kafés
router.get('/', kafeController.getKafes);

// Route pour mettre à jour un Kafé par ID
router.put('/:kafeId', kafeController.updateKafe);

module.exports = router;
