import 'package:flutter/material.dart';
import '../utils/filter_options.dart';

class FilterThumbnail extends StatelessWidget {
  final FilterOption filter;
  final FilterOption currentFilter;
  final VoidCallback onTap;

  const FilterThumbnail({
    super.key,
    required this.filter,
    required this.currentFilter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          currentFilter == filter ? Colors.purple : Colors.yellow[300], // Lila para selección, amarillo como secundario
        ),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Bordes más suaves
        )),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 16, vertical: 8)), // Aumento de tamaño del botón
      ),
      child: Text(
        filter.name,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white, // Color del texto blanco
          fontWeight: FontWeight.bold, // Hacemos el texto en negrita
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class FilterList extends StatelessWidget {
  final FilterOption currentFilter;
  final Function(FilterOption) onFilterSelected;

  const FilterList({
    super.key,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: EdgeInsets.symmetric(vertical: 8), // Espaciado entre los filtros
      child: SizedBox(
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: FilterPresets.filters.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4), // Aumentar el espaciado entre los botones
              child: FilterThumbnail(
                filter: FilterPresets.filters[index],
                currentFilter: currentFilter,
                onTap: () => onFilterSelected(FilterPresets.filters[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
