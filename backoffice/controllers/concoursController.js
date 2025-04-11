// /backoffice/controllers/concoursController.js
const Concours = require('../models/concours');

// Créer un Concours
exports.createConcours = async (req, res) => {
  const { kafe_id, quantite } = req.body;

  const concours = new Concours({ kafe_id, quantite });

  try {
    const savedConcours = await concours.save();
    res.status(201).json(savedConcours);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Obtenir tous les concours soumis
exports.getConcours = async (req, res) => {
  try {
    const concours = await Concours.find();
    res.status(200).json(concours);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
