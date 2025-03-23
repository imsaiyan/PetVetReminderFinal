const mongoose = require('mongoose');

// Definir el esquema del producto
const productSchema = new mongoose.Schema({
    nombre: {
        type: String,
        required: true
    },
    categoria: {
        type: String,
        required: true
    },
    ubicacion: {
        type: String,
        required: true
    },
    cantidad: {
        type: Number,
        required: true
    },
    fechaCreacion: {
        type: Date,
        default: Date.now()
    }
    // Otros campos relevantes para tu producto
});

const Product = mongoose.model('Producto', productSchema);

module.exports = Product;
