const Mascota = require("../models/mascota");

// Crear una nueva mascota
exports.crearMascota = async (req, res) => {
    try {
        const { nombre, raza, edad, historialMedico } = req.body;
        const nuevaMascota = new Mascota({ nombre, raza, edad, historialMedico });

        await nuevaMascota.save();
        res.status(201).json({ mensaje: "Mascota registrada correctamente", mascota: nuevaMascota });
    } catch (error) {
        res.status(500).json({ mensaje: "Error al registrar la mascota", error: error.message });
    }
};

// Obtener todas las mascotas
exports.obtenerMascotas = async (req, res) => {
    try {
        const mascotas = await Mascota.find();
        res.status(200).json(mascotas);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al obtener las mascotas", error: error.message });
    }
};

// Obtener una mascota por ID
exports.obtenerMascotaPorId = async (req, res) => {
    try {
        const mascota = await Mascota.findById(req.params.id);
        if (!mascota) {
            return res.status(404).json({ mensaje: "Mascota no encontrada" });
        }
        res.status(200).json(mascota);
    } catch (error) {
        res.status(500).json({ mensaje: "Error al obtener la mascota", error: error.message });
    }
};

// Actualizar una mascota por ID
exports.actualizarMascota = async (req, res) => {
    try {
        const { nombre, raza, edad, historialMedico } = req.body;
        const mascotaActualizada = await Mascota.findByIdAndUpdate(
            req.params.id,
            { nombre, raza, edad, historialMedico },
            { new: true }
        );

        if (!mascotaActualizada) {
            return res.status(404).json({ mensaje: "Mascota no encontrada" });
        }

        res.status(200).json({ mensaje: "Mascota actualizada correctamente", mascota: mascotaActualizada });
    } catch (error) {
        res.status(500).json({ mensaje: "Error al actualizar la mascota", error: error.message });
    }
};

// Eliminar una mascota por ID
exports.eliminarMascota = async (req, res) => {
    try {
        const mascotaEliminada = await Mascota.findByIdAndDelete(req.params.id);
        if (!mascotaEliminada) {
            return res.status(404).json({ mensaje: "Mascota no encontrada" });
        }
        res.status(200).json({ mensaje: "Mascota eliminada correctamente" });
    } catch (error) {
        res.status(500).json({ mensaje: "Error al eliminar la mascota", error: error.message });
    }
};
