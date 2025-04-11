const mongoose = require('mongoose');

const joueurSchema = new mongoose.Schema({
  nom: { type: String, required: true },
  prenom: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  bourse: { type: Number, default: 0 }, // DéeVee
  date_creation: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Joueur', joueurSchema);
