import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petvet_reminder/widgets/app_drawer.dart';
import 'package:petvet_reminder/services/Pet.Services.dart';

class AgregarMascotaScreen extends StatefulWidget {
  const AgregarMascotaScreen({super.key});

  @override
  _AgregarMascotaScreenState createState() => _AgregarMascotaScreenState();
}

class _AgregarMascotaScreenState extends State<AgregarMascotaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _razaController = TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _historialMedicoController =
      TextEditingController();
  final PetService _petService = PetService(); // Instancia del servicio

  Future<void> _guardarMascota() async {
    if (_formKey.currentState?.validate() ?? false) {
      String nombre = _nombreController.text.trim();
      String raza = _razaController.text.trim();
      int edad = int.tryParse(_edadController.text.trim()) ?? 0;
      String historialMedico = _historialMedicoController.text.trim();

      try {
        bool success = await _petService.addPet(
          nombre,
          raza,
          edad,
          historialMedico,
        );
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Mascota guardada con éxito')));
          context.pop(); // Regresar a la pantalla anterior
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar la mascota')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de conexión: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Mascota'),
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la Mascota',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingresa el nombre'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _razaController,
                decoration: const InputDecoration(labelText: 'Raza'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingresa la raza'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _edadController,
                decoration: const InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingresa la edad'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _historialMedicoController,
                decoration: const InputDecoration(
                  labelText: 'Historial Médico',
                ),
                maxLines: 5,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingresa el historial médico'
                            : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _guardarMascota,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Guardar Mascota',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
