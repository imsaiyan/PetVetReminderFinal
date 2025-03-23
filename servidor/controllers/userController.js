const User = require('../models/userModel');

exports.registerUser = async (req, res) => {
    try {
        const { username, password } = req.body; // Extraer datos correctamente

        if (!username || !password) {
            return res.status(400).json({ error: "Todos los campos son obligatorios" });
        }

      
        res.status(201).json({ message: "Usuario registrado con éxito" });
        const newUser = new User({ username, password });

        await newUser.save();

    } catch (error) {
        console.error("Error al registrar usuario:", error);
        res.status(500).json({ error: "Error interno del servidor" });
   }
};


exports.loginUser = async (req, res) => {
    const { username, password } = req.body;

    try {
        // Busca el usuario en la base de datos
        const user = await User.findOne({ username });
        if (!user) {
            return res.status(400).json({ error: 'Usuario no encontrado' });
        }

        // Verifica la contraseña (sin bcrypt)
        if (user.password !== password) {
            return res.status(400).json({ error: 'Credenciales incorrectas' });
        }

        res.json({ message: 'Inicio de sesión exitoso', user });
    } catch (error) {
        console.error('Error en el inicio de sesión:', error);
        res.status(500).json({ error: 'Error en el inicio de sesión' });
    }
};


