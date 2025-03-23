import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/services.dart'; // Importa el servicio

class LoginRegister extends StatefulWidget {
  const LoginRegister({super.key});

  @override
  State<LoginRegister> createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final TextEditingController _loginUsernameController = TextEditingController();
  final TextEditingController _loginPasswordController = TextEditingController();
  final TextEditingController _registerUsernameController = TextEditingController();
  final TextEditingController _registerPasswordController = TextEditingController();

  bool _isLoginMode = true; // Alternar entre login y registro
  final AuthService _authService = AuthService(); // Instancia del servicio de autenticación

  void _toggleAuthMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
  }

  Future<void> _submit() async {
    if (_isLoginMode) {
      // Lógica para iniciar sesión
      String username = _loginUsernameController.text.trim();
      String password = _loginPasswordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        _showMessage("Los campos no pueden estar vacíos.");
        return;
      }

      try {
        var response = await _authService.loginUser(username, password);
        print("Respuesta del servidor (Login): $response");

        if (response != null && response.containsKey("error")) {
          _showMessage(response["error"]);
        } else {
          _showMessage("Inicio de sesión exitoso.", success: true);
          if (mounted) context.go('/Home'); // Navegar a la pantalla de inicio
        }
      } catch (e) {
        _showMessage("Error al iniciar sesión: $e");
      }
    } else {
      // Lógica para registrarse
      String username = _registerUsernameController.text.trim();
      String password = _registerPasswordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        _showMessage("Todos los campos son obligatorios.");
        return;
      }

      try {
        var response = await _authService.registerUser(username, password);
        print("Respuesta del servidor (Registro): $response");

        if (response != null && response.containsKey("error")) {
          _showMessage(response["error"]);
        } else {
          _showMessage("Registro exitoso.", success: true);
          if (mounted) context.go('/Home'); // Navegar a la pantalla de inicio
        }
      } catch (e) {
        _showMessage("Error al registrar: $e");
      }
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isLoginMode ? Icons.lock_outline : Icons.person_add,
                  size: 80,
                  color: const Color.fromARGB(255, 108, 167, 215),
                ),
                const SizedBox(height: 16),
                Text(
                  _isLoginMode ? 'Bienvenido' : 'Crea tu cuenta',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                if (_isLoginMode)
                  Column(
                    children: [
                      _buildTextField(
                        controller: _loginUsernameController,
                        label: 'Nombre de usuario',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _loginPasswordController,
                        label: 'Contraseña',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildTextField(
                        controller: _registerUsernameController,
                        label: 'Nombre de usuario',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _registerPasswordController,
                        label: 'Contraseña',
                        icon: Icons.lock,
                        obscureText: true,
                      ),
                    ],
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submit,
                  child: Text(
                    _isLoginMode ? 'Iniciar Sesión' : 'Registrarse',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _toggleAuthMode,
                  child: Text(
                    _isLoginMode
                        ? '¿No tienes cuenta? Regístrate aquí'
                        : '¿Ya tienes cuenta? Inicia sesión',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 108, 167, 215),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 108, 167, 215)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
