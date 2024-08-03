import 'package:flutter/material.dart';

Widget buildBackView(int index) {
  return Card(
    clipBehavior: Clip.antiAlias,
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: GridView.count(
        crossAxisCount: 2, // Incrementa a tres ítems por fila para una mejor distribución
        mainAxisSpacing: 2.0, // Reduce el espaciado vertical entre las tarjetas
        crossAxisSpacing: 2.0, // Reduce el espaciado horizontal entre las tarjetas
        childAspectRatio: 1.3, // Ajusta la proporción para que sea más ancha
        //physics: NeverScrollableScrollPhysics(), // Desactiva el scroll en GridView
        shrinkWrap: true, // Ajusta el tamaño del GridView al contenido
        children: <Widget>[
          _buildFeatureCard(Icons.door_sliding, '4 puertas', 24, 6),
          _buildFeatureCard(Icons.ac_unit, 'Aire acondicionado', 24, 6),
          _buildFeatureCard(Icons.electric_car, 'Levantavidrios eléctricos', 24, 6),
          _buildFeatureCard(Icons.lock, 'Cierre centralizado', 24, 6),
          _buildFeatureCard(Icons.directions_car_filled, 'Dirección Asistida', 24, 6),
          _buildFeatureCard(Icons.no_crash, 'Air bag', 24, 6),
          _buildFeatureCard(Icons.work, '1 maleta(s) grande(s)', 24, 6),
          _buildFeatureCard(Icons.work_outline, '2 maleta(s) pequeña(s)', 24, 6),
          _buildFeatureCard(Icons.group, '6 personas', 24, 6),
          
        ],
      ),
    ),
  );
}

Widget _buildFeatureCard(IconData icon, String text, double iconSize, double textSize) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white, // Fondo blanco para las tarjetas
      borderRadius: BorderRadius.circular(10), // Bordes redondeados
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: iconSize, color: Colors.teal), // Reducción del tamaño del ícono
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(text, style: TextStyle(fontSize: textSize), textAlign: TextAlign.center),
        ),
      ],
    ),
  );
}
