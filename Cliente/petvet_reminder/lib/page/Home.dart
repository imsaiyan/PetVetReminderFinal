import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Para codificar y decodificar JSON
import '../widgets/app_drawer.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _reminders = {};

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
      setState(() {
        _reminders = remindersMap.map(
          (key, value) =>
              MapEntry(DateTime.parse(key), List<String>.from(value)),
        );
      });
    }
  }

  // Guardar recordatorios en SharedPreferences
  Future<void> _saveReminders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String remindersJson = jsonEncode(
      _reminders.map((key, value) => MapEntry(key.toIso8601String(), value)),
    );
    await prefs.setString('reminders', remindersJson);
  }

  void _addReminder(DateTime day) {
    TextEditingController reminderController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Agregar Recordatorio'),
            content: TextField(
              controller: reminderController,
              decoration: const InputDecoration(
                hintText: 'Escribe tu recordatorio',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (reminderController.text.isNotEmpty) {
                    setState(() {
                      _reminders[day] ??= [];
                      _reminders[day]!.add(reminderController.text);
                    });
                    _saveReminders(); // Guardar en SharedPreferences
                  }
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PetVet Reminder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/agregar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Registrar Mascotas',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/ver'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Ver Mascotas',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Calendario',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TableCalendar(
                      firstDay: DateTime.utc(2020, 1, 1),
                      lastDay: DateTime.utc(2030, 12, 31),
                      focusedDay: _focusedDay,
                      selectedDayPredicate:
                          (day) => isSameDay(_selectedDay, day),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _addReminder(selectedDay);
                      },
                      eventLoader: (day) => _reminders[day] ?? [],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
