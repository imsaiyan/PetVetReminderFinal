import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:petvet_reminder/widgets/app_drawer.dart';

class AddListNews extends StatefulWidget {
  const AddListNews({super.key}); // Agregar const al constructor

  @override
  _AddListNewsState createState() => _AddListNewsState();
}

class _AddListNewsState extends State<AddListNews> {
  List<Map<String, String>> newsList = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  // Cargar recordatorios desde SharedPreferences
  Future<void> _loadReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? remindersJson = prefs.getString('reminders');

    if (remindersJson != null) {
      Map<String, dynamic> remindersMap = jsonDecode(remindersJson);
      List<Map<String, String>> remindersList = [];

      remindersMap.forEach((date, reminders) {
        for (var reminder in reminders) {
          remindersList.add({
            'title': 'Recordatorio - $date',
            'content': reminder,
          });
        }
      });

      setState(() {
        newsList = remindersList;
      });
    }
  }

  // Limpiar todas las notificaciones
  Future<void> _clearNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(
      'reminders',
    ); // Eliminar recordatorios de SharedPreferences
    setState(() {
      newsList.clear(); // Limpiar la lista en la interfaz
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // Constante para el Drawer
      appBar: AppBar(
        title: const Text('Notificaciones'), // Constante para el título
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete), // Constante para el ícono
            onPressed: () {
              if (newsList.isNotEmpty) {
                _clearNotifications(); // Llamar a la función para limpiar notificaciones
              }
            },
            tooltip: 'Limpiar Notificaciones',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Constante para el padding
        child: Column(
          children: [
            if (newsList.isEmpty)
              const Center(
                child: Text(
                  'No hay notificaciones disponibles.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: newsList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 8.0,
                      ), // Constante para el margen
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color.fromARGB(255, 108, 167, 215),
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                        title: Text(
                          newsList[index]['title']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ), // Constante para el estilo
                        ),
                        subtitle: Text(newsList[index]['content']!),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
