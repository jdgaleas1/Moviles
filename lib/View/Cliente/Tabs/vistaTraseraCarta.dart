import 'package:flutter/material.dart';

Widget buildBackView(List<String> caracteristicas) {
  final Map<String, IconData> iconMap = {
    '4 puertas': Icons.door_sliding,
    'Aire acondicionado': Icons.ac_unit,
    'Levantavidrios eléctricos': Icons.electric_car,
    'Cierre centralizado': Icons.lock,
    'Dirección Asistida': Icons.directions_car_filled,
    'Air bag': Icons.no_crash,
    '1 maleta(s) grande(s)': Icons.work,
    '2 maleta(s) pequeña(s)': Icons.work_outline,
    '6 personas': Icons.group,
  };

  return Card(
    clipBehavior: Clip.antiAlias,
    child: Container(
      padding: const EdgeInsets.all(8),
      constraints: BoxConstraints(maxHeight: 300),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0, // Espaciado vertical reducido
          crossAxisSpacing: 1.0, // Espaciado horizontal reducido
          childAspectRatio: 1.2, // Ajusta la proporción para que sea más ancha
        ),
        itemCount: caracteristicas.length,
        itemBuilder: (context, index) {
          final caracteristica = caracteristicas[index];
          return _buildFeatureCard(
            iconMap[caracteristica] ?? Icons.help_outline,
            caracteristica,
            20,  // Tamaño del ícono
            6,   // Tamaño del texto reducido
          );
        },
      ),
    ),
  );
}

Widget _buildFeatureCard(IconData icon, String text, double iconSize, double textSize) {
  return Container(
    padding: const EdgeInsets.all(2.0),

    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: iconSize, color: Colors.teal),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(text, style: TextStyle(fontSize: textSize), textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}
