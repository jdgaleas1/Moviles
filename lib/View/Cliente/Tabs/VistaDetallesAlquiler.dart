import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class DetallesAlquilerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String coche = "Mazda de 4 puertas - nombre: -----------";
    final String message = 'Mira este enlace de alquiler de coches!';
    final double precio = 59.99; // Precio del alquiler por día

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Elimina la sombra del AppBar para un look más limpio
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share), // Icono de compartir
            onPressed: () {
              FlutterShareMe().shareToWhatsApp(msg: '$message $coche Alquiler: $precio');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/car.png', // Sustituye con la ruta de tu imagen o vídeo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Características del Coche',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3, // Aspect ratio para cada tarjeta
                      children: [
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
                  SizedBox(height: 10),
                  Text(
                    'Precio por día: \$${precio.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // Color de fondo del botón
                        foregroundColor: Colors.white, // Color del texto e ícono
                      ),
                      onPressed: () => NotificationHelper.showAddedNotification(context),
                      child: Text('Alquilar Ahora'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String text, double iconSize, double fontSize) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(icon, size: iconSize, color: Colors.teal),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: fontSize),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
