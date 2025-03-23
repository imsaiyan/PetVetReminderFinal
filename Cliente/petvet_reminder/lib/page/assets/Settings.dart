import 'package:flutter/material.dart';
import 'package:petvet_reminder/widgets/app_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedTheme = 'Light';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),

      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.blue.shade300, // Azul cielo en el appBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildSettingsOption(
              icon: Icons.person,
              title: 'Editar perfil',
              onTap: () {},
            ),
            _buildSettingsOption(
              icon: Icons.notifications,
              title: 'Habilitar Notificaciones',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
            ),
            _buildSettingsOption(
              icon: Icons.palette,
              title: 'Tema de la Aplicación',
              trailing: DropdownButton<String>(
                value: _selectedTheme,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedTheme = newValue!;
                  });
                },
                items:
                    <String>['Light', 'Dark'].map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
              ),
            ),
            _buildSettingsOption(
              icon: Icons.lock,
              title: 'Privacidad',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50, // Azul cielo claro de fondo
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            child: const Icon(Icons.person, size: 30, color: Colors.black),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Nombre de Usuario',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'usuario@example.com',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsOption({
    required IconData icon,
    required String title,
    Widget? trailing,
    Color iconColor = Colors.blue, // Azul cielo para los íconos
    Color textColor = Colors.black,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor),
          title: Text(title, style: TextStyle(color: textColor)),
          trailing:
              trailing ??
              const Icon(Icons.arrow_forward_ios, color: Colors.black),
          onTap: onTap,
        ),
        const Divider(),
      ],
    );
  }
}
