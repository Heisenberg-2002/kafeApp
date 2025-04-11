// /backoffice/models/kafe.js
const mongoose = require('mongoose');

const kafeSchema = new mongoose.Schema({
  nom: { type: String, required: true },
  avatar: { type: String, default: '' },
  gout: { type: Number, required: true },
  amertume: { type: Number, required: true },
  teneur: { type: Number, required: true },
  odorat: { type: Number, required: true },
  rendementFruit: { type: Number, required: true },
});

module.exports = mongoose.model('Kafe', kafeSchema);
