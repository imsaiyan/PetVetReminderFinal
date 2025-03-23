import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl =
      "http://localhost:4000/api/users"; // Cambia si usas otro puerto

  /// Método para registrar un usuario
  Future<Map<String, dynamic>?> registerUser(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/');

    try {
      print(
        "Enviando solicitud a $url con username: $username y password: $password",
      ); // Depuración

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      print(
        "Respuesta del servidor: ${response.statusCode} - ${response.body}",
      ); // Depuración

      return _handleResponse(response, successCode: 201);
    } catch (e) {
      print("Error en la conexión: $e"); // Depuración
      return {"error": "Error en la conexión: ${e.toString()}"};
    }
  }

  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      return _handleResponse(response, successCode: 200);
    } catch (e) {
      return {"error": "Error en la conexión: ${e.toString()}"};
    }
  }

  /// Método privado para manejar respuestas del servidor
  Map<String, dynamic>? _handleResponse(
    http.Response response, {
    required int successCode,
  }) {
    try {
      if (response.statusCode == successCode) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body)['error'] ?? "Error desconocido";
        return {"error": error};
      }
    } catch (e) {
      return {
        "error": "Error al procesar la respuesta del servidor: ${e.toString()}",
      };
    }
  }
}
