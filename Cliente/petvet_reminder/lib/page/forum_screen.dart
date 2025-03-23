import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petvet_reminder/widgets/app_drawer.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  final List<Map<String, String>> _posts = [];
  final ScrollController _scrollController = ScrollController();
  int _postCount = 5;

  @override
  void initState() {
    super.initState();
    _generatePosts();
    _scrollController.addListener(_loadMorePosts);
  }

  void _generatePosts() {
    int start = _posts.length;
    for (int i = start; i < start + _postCount; i++) {
      _posts.add({
        'username': 'Usuario $i',
        'content': 'Este es un mensaje de prueba número $i en el foro.',
        'hasPhoto':
            i % 2 == 0
                ? 'true'
                : 'false', // Simulamos que algunos posts tienen foto
      });
    }
  }

  void _loadMorePosts() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      setState(() {
        _postCount = 5; // Cargar menos posts por vez para un efecto suave
        _generatePosts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text(
          'Foro de Mascotas',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // Cambié el color del texto a blanco
          ),
        ),
        backgroundColor: Colors.blue.shade300, // Azul cielo para el fondo
        centerTitle: true,
      ),
      body: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        itemCount: _posts.length + 1, // +1 para simular carga
        itemBuilder: (context, index) {
          if (index == _posts.length) {
            return _buildLoadingIndicator();
          }
          return _buildPost(
            _posts[index]['username']!,
            _posts[index]['content']!,
            _posts[index]['hasPhoto'] == 'true', // Verifica si tiene foto
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/post'); // Navega a la pantalla de nuevo post
        },
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPost(String username, String content, bool hasPhoto) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: const Color.fromARGB(255, 108, 167, 215),
              child: const Icon(Icons.person, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black, // Color negro para los nombres
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    content,
                    style: TextStyle(
                      color: Colors.grey.shade800,
                    ), // Gris oscuro para el contenido
                  ),
                  if (hasPhoto)
                    _buildPhoto(context), // Mostrar la foto si tiene una
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoto(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navegar a la vista de foto a pantalla completa
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FullScreenPhotoView()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          width: double.infinity,
          height: 150,
          color: Colors.black,
          child: Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 40,
          ), // Ícono de cámara
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 83, 140, 194),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class FullScreenPhotoView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vista Completa de Foto'),
        backgroundColor: const Color.fromARGB(255, 108, 167, 215),
        centerTitle: true,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            // Al tocar la foto, se regresa a la pantalla anterior
            Navigator.pop(context);
          },
          child: Container(
            color: Colors.black,
            width: double.infinity,
            height: double.infinity,
            child: const Icon(Icons.camera_alt, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }
}
