import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    final picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: source);
      if (image != null) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditPage(imageFile: image)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ups, algo salió mal al tomar la imagen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magic Photo Editor'),
        backgroundColor: Colors.purple, // Fondo del AppBar lila
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco para el cuerpo
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // La imagen cubre todo el fondo
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera, context),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Toma una foto'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Fondo lila del botón
                  foregroundColor: Colors.white, // Color blanco del texto e íconos
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery, context),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería de imágenes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple, // Fondo lila del botón
                  foregroundColor: Colors.white, // Color blanco del texto e íconos
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
