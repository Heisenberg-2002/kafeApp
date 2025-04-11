// /backoffice/models/concours.js
const mongoose = require('mongoose');

const concoursSchema = new mongoose.Schema({
  kafe_id: { type: String, required: true },
  quantite: { type: Number, required: true },
  date_soumission: { type: Date, default: Date.now },
});

module.exports = mongoose.model('Concours', concoursSchema);
