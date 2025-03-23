require('dotenv').config({ path: 'database.env' });
const mongoose = require('mongoose');

const conectarDB = async () => {
    try {
        await mongoose.connect(process.env.db_conecion, { });
        console.log('Conexión a la base de datos exitosa');
    } catch (error) {
        console.error('Error al conectar a la base de datos:');
    }
}

module.exports = conectarDB;
