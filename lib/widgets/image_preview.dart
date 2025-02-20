import 'package:flutter/material.dart';
import '../utils/filter_options.dart';

class ImagePreview extends StatelessWidget {
  final GlobalKey globalKey;
  final Image image;
  final FilterOption currentFilter;

  const ImagePreview({
    super.key,
    required this.globalKey,
    required this.image,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8), // Espaciado interno alrededor de la imagen
      child: Expanded(
        child: RepaintBoundary(
          key: globalKey,
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(currentFilter.matrix),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), // Bordes redondeados para la imagen
                border: Border.all(
                  color: Colors.purple, // Bordes de color lila
                  width: 2, // Grosor del borde
                ),
              ),
              child: image,
            ),
          ),
        ),
      ),
    );
  }
}
