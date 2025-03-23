import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _controller = TextEditingController();

  void _postMessage() {
    if (_controller.text.isNotEmpty) {
      // Aquí puedes manejar el envío del mensaje
      context.pop(); // Regresar a la pantalla anterior (foro)
    }
  }

  @override
  Widget build(BuildContext context) {
    // Obtener las dimensiones de la pantalla para hacer los elementos más responsivos
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Post'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ElevatedButton(
              onPressed: _postMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal:
                      screenWidth > 600
                          ? 30
                          : 20, // Ajustar el padding para pantallas grandes
                  vertical:
                      screenWidth > 600
                          ? 15
                          : 10, // Ajustar el padding para pantallas grandes
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Post',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _controller,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Escribe tu mensaje...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    // Acción para agregar opciones
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.image_outlined,
                    size: 30,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    // Acción para adjuntar una imagen
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (screenWidth <=
                600) // Hacer el botón de "Post" más grande en pantallas grandes
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _postMessage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 108, 167, 215),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal:
                          screenWidth * 0.4, // Usamos un porcentaje del ancho
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Publicar',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
