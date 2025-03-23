const express = require('express');
const session = require('express-session');
const conectarDB = require('./config/db');
const cors = require('cors');

const app = express();
const PORT = 4000;

// Conectar a la base de datos
conectarDB();

// Configuración de la sesión


// Middleware
app.use(cors());
app.use(express.json());

// Ruta raíz con mensaje
app.get('/', (req, res) => {
  res.send('Bienvenido a la API de petvet_reminder');
});

// Rutas
//app.use('/api/productos', require('./routes/productos'));
app.use('/api/users', require('./routes/userRoutes'));
app.use('/api/mascotas', require('./routes/mascotaRoutes'));

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor iniciado en el puerto ${PORT}`);
  console.log(`http://localhost:${PORT}/`);
});
