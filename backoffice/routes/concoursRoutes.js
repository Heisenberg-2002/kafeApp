// /backoffice/routes/concoursRoutes.js
const express = require('express');
const router = express.Router();
const concoursController = require('../controllers/concoursController');

// Route pour créer un concours
router.post('/', concoursController.createConcours);

// Route pour obtenir tous les concours
router.get('/', concoursController.getConcours);

module.exports = router;
