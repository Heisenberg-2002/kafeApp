// /backoffice/server.js
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');

// Importer les routes
const joueurRoutes = require('./routes/joueurRoutes');
const kafeRoutes = require('./routes/kafeRoutes');
const concoursRoutes = require('./routes/concoursRoutes');

const app = express();
app.use(bodyParser.json());

// Connexion à MongoDB
mongoose.connect('mongodb://localhost:27017/kafeApp', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Database connected'))
  .catch((err) => console.log('Error connecting to database:', err));

// Utilisation des routes
app.use('/api/joueurs', joueurRoutes);
app.use('/api/kafes', kafeRoutes);
app.use('/api/concours', concoursRoutes);

// Démarrer le serveur
app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
