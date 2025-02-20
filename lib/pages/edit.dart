import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
import '../utils/filter_options.dart';
import '../services/permission_service.dart';
import '../services/image_saver.dart';
import '../services/media_scanner.dart';
import '../widgets/filter_list.dart';
import '../widgets/image_preview.dart';

class EditPage extends StatefulWidget {
  final XFile imageFile;

  const EditPage({super.key, required this.imageFile});

  @override
  State<EditPage> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditPage> {
  final GlobalKey _globalKey = GlobalKey();
  late Image _image;
  late FilterOption _currentFilter;

  @override
  void initState() {
    super.initState();
    _image = Image.file(File(widget.imageFile.path));
    _currentFilter = FilterPresets.filters.first;
  }

  // Función para guardar imagen
  Future<void> _saveImage() async {
    if (!await PermissionService.requestStoragePermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se necesita permiso para acceder a tu almacenamiento')),
        );
      }
      return;
    }

    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      final String? savedPath = await ImageSaver.saveImage(image);

      if (savedPath != null) {
        await MediaScanner.scanFile(savedPath);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('¡Se guardó la imagen en tu galería!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ups, algo salió mal al guardar en tu galería: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar foto'),
        backgroundColor: Colors.purple, // Fondo del AppBar lila
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveImage,
            color: Colors.white, // Color del ícono en blanco
          ),
        ],
      ),
      body: Container(
        // Fondo de imagen que ocupa todo el espacio disponible
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondo.jpg'), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // La imagen cubre toda la pantalla
          ),
        ),
        child: Center(  // Center widget para centrar todo el contenido
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Espaciado alrededor del contenido
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centra los elementos dentro de la columna
              children: [
                // Vista previa de la imagen con filtro
                ImagePreview(
                  globalKey: _globalKey,
                  image: _image,
                  currentFilter: _currentFilter,
                ),
                SizedBox(height: 16),  // Espacio entre el preview y los filtros
                // Filtros
                FilterList(
                  currentFilter: _currentFilter,
                  onFilterSelected: (filter) {
                    setState(() => _currentFilter = filter);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
