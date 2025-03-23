const mongoose = require("mongoose");

const MascotaSchema = new mongoose.Schema({
    nombre: {
        type: String,
        required: true,
        trim: true
    },
    raza: {
        type: String,
        required: true,
        trim: true
    },
    edad: {
        type: Number,
        required: true
    },
    historialMedico: {
        type: String,
        required: true
    },
    fechaCreacion: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model("Mascota", MascotaSchema);
