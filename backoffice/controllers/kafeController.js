// /backoffice/controllers/kafeController.js
const Kafe = require('../models/kafe');

// Créer un Kafé
exports.createKafe = async (req, res) => {
  const { nom, avatar, gout, amertume, teneur, odorat, rendementFruit } = req.body;
  
  const kafe = new Kafe({ nom, avatar, gout, amertume, teneur, odorat, rendementFruit });
  
  try {
    const savedKafe = await kafe.save();
    res.status(201).json(savedKafe);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Obtenir tous les Kafés
exports.getKafes = async (req, res) => {
  try {
    const kafes = await Kafe.find();
    res.status(200).json(kafes);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};

// Mettre à jour un Kafé
exports.updateKafe = async (req, res) => {
  const { kafeId } = req.params;
  const updates = req.body;

  try {
    const updatedKafe = await Kafe.findByIdAndUpdate(kafeId, updates, { new: true });
    res.status(200).json(updatedKafe);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};
