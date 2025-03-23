import 'package:flutter/material.dart';
import 'package:petvet_reminder/widgets/app_drawer.dart';
import 'package:petvet_reminder/services/Pet.Services.dart';

class VerMascotaScreen extends StatefulWidget {
  const VerMascotaScreen({super.key});

  @override
  _VerMascotaScreenState createState() => _VerMascotaScreenState();
}

class _VerMascotaScreenState extends State<VerMascotaScreen> {
  final PetService _petService = PetService();
  late Future<List<Map<String, dynamic>>> _mascotasFuture;

  @override
  void initState() {
    super.initState();
    _mascotasFuture = _cargarMascotas();
  }

  Future<List<Map<String, dynamic>>> _cargarMascotas() async {
    try {
      return await _petService.getPets();
    } catch (e) {
      return Future.error("Error al cargar mascotas: $e");
    }
  }

  // Método para editar solo el historial médico
  void _editarHistorialMedico(Map<String, dynamic> mascota) async {
    final TextEditingController historialController = TextEditingController(
      text: mascota['historialMedico'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Historial Médico'),
          content: TextField(
            controller: historialController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Historial Médico',
              hintText: 'Introduce el nuevo historial médico...',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (historialController.text.isNotEmpty) {
                  bool success = await _petService.updatePet(
                    mascota['_id'], // Usamos _id en lugar de id
                    mascota['nombre'],
                    mascota['raza'],
                    mascota['edad'],
                    historialController.text, // Nuevo historial médico
                  );
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Historial médico actualizado'),
                      ),
                    );
                    setState(() {
                      _mascotasFuture =
                          _cargarMascotas(); // Refrescar la lista de mascotas
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error al actualizar el historial'),
                      ),
                    );
                  }
                }
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Método para borrar una mascota
  void _borrarMascota(String id) async {
    try {
      bool success = await _petService.deletePet(id);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mascota eliminada con éxito')),
        );
        setState(() {
          _mascotasFuture = _cargarMascotas(); // Refrescar la lista de mascotas
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al eliminar la mascota')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ver Mascotas'),
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _mascotasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay mascotas registradas"));
          }

          final mascotas = snapshot.data!;
          mascotas.sort(
            (a, b) => (a['edad'] as int).compareTo(b['edad'] as int),
          );

          return ListView.builder(
            itemCount: mascotas.length,
            itemBuilder: (context, index) {
              final mascota = mascotas[index];
              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mascota['nombre'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text('Raza: ${mascota['raza']}'),
                      Text('Edad: ${mascota['edad']} años'),
                      const SizedBox(height: 10),
                      // ExpansionTile para mostrar el historial médico
                      ExpansionTile(
                        title: const Text(
                          'Ver Historial Médico',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              mascota['historialMedico'] ??
                                  'Historial no disponible',
                              style: TextStyle(color: Colors.grey.shade700),
                            ),
                          ),
                        ],
                      ),
                      // Fila con íconos para editar y borrar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editarHistorialMedico(mascota),
                            color: Colors.orange,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              // Confirmación para eliminar
                              showDialog(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text(
                                        'Confirmar eliminación',
                                      ),
                                      content: const Text(
                                        '¿Estás seguro de que quieres eliminar esta mascota?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _borrarMascota(
                                              mascota['_id'],
                                            ); // Usamos _id
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    ),
                              );
                            },
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
