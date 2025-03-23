import 'dart:convert';
import 'package:http/http.dart' as http;

class PetService {
  final String baseUrl =
      "http://localhost:4000/api/mascotas"; // Cambia esto si usas otro host

  // Obtener todas las mascotas
  Future<List<Map<String, dynamic>>> getPets() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> petsJson = jsonDecode(response.body);
        return petsJson.cast<Map<String, dynamic>>();
      } else {
        throw Exception("Error al obtener las mascotas");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Obtener una mascota por ID
  Future<Map<String, dynamic>> getPetById(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/$id"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Mascota no encontrada");
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Crear una nueva mascota
  Future<bool> addPet(
    String nombre,
    String raza,
    int edad,
    String historialMedico,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "raza": raza,
          "edad": edad,
          "historialMedico": historialMedico,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Actualizar una mascota
  Future<bool> updatePet(
    String id,
    String nombre,
    String raza,
    int edad,
    String historialMedico,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": nombre,
          "raza": raza,
          "edad": edad,
          "historialMedico": historialMedico,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception("Error de conexión: $e");
    }
  }

  // Eliminar una mascota
  Future<bool> deletePet(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'), // Asegúrate de que la URL sea correcta
      );

      if (response.statusCode == 200) {
        return true; // La mascota se eliminó con éxito
      } else {
        return false; // Hubo un error
      }
    } catch (e) {
      throw Exception('Error al eliminar la mascota: $e');
    }
  }
}
