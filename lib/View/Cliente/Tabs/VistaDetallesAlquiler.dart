import 'dart:convert';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/EstadosModel.dart';
import 'package:autos/Model/alquilerModel.dart';
import 'package:autos/Servicios/alquilerService.dart';
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/tabBuscar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:provider/provider.dart';

class DetallesAlquilerPage extends StatelessWidget {
  final Auto auto;
  final AlquilerService _alquilerService = AlquilerService(); // Instancia del servicio de alquiler

  DetallesAlquilerPage({required this.auto});
    Future<void> _agregarReserva(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String? usuarioActualID = userProvider.idUsuario;

    if (usuarioActualID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo obtener la información del usuario.')),
      );
      return;
    }

    // Buscar si ya existe una reserva para este auto y usuario
    QuerySnapshot existingReservations = await FirebaseFirestore.instance
        .collection('alquiler')
        .where('autoID', isEqualTo: auto.id.toString())
        .where('usuarioID', isEqualTo: usuarioActualID)
        .get();

    if (existingReservations.docs.isEmpty) {
      // Si no existe una reserva, crea una nueva
      Alquiler alquiler = Alquiler(
        id_alquiler: '', 
        autoID: auto.id.toString(),
        disponible: true,
        estado: false,
        usuarioID: usuarioActualID,
      );

      try {
        await _alquilerService.agregarAlquiler(alquiler);
        NotificationHelper.showAddedNotification(context);
      } catch (e) {
        print('Error al agregar la reserva: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al realizar la reserva.')),
        );
      }
    } else {
      // Si ya existe una reserva, muestra un mensaje de error o notificación
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ya tienes una reserva para este auto.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String message = 'Que te parece este cohe que esta en alquiler en Rental Card!';
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => BuscarTab()),
                            );
            },
          ),

          IconButton(
            icon: const Icon(Icons.ios_share),
            onPressed: () {
            FlutterShareMe().shareToWhatsApp(
              msg: '$message\nMarca: ${auto.marca}\nAlquiler: \$${auto.precio}\nUbicado: ${auto.ciudad}, ${auto.provincia}\nPlaca: ${auto.placa}\nCaracteristicas: ${auto.caracteristicas}'
              );
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
              child: auto.imageBase64.isNotEmpty
                  ? Image.memory(base64Decode(auto.imageBase64), fit: BoxFit.cover)
                  : Image.asset('assets/images/car.png', fit: BoxFit.cover),
            ),
          ),
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalles del Coche',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    _buildDetailItem(Icons.directions_car, 'Marca: ${auto.marca}'),
                    _buildDetailItem(Icons.confirmation_number, 'Placa: ${auto.placa}'),
                    _buildDetailItem(Icons.location_on, 'Ubicación: ${auto.ciudad}, ${auto.provincia}'),
                    _buildDetailItem(Icons.description, 'Descripción: ${auto.descripcion}'),
                    SizedBox(height: 20),
                    Text(
                      'Características del Coche',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: auto.caracteristicas.split(', ').map((feature) {
                        return _buildFeatureCard(_getIconForFeature(feature), feature, 24, 6);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Precio de alquiler: \$${auto.precio}',
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _agregarReserva(context),
                    child: Text('Alquilar Ahora'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
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

  IconData _getIconForFeature(String feature) {
    switch (feature) {
      case '4 puertas':
        return Icons.door_sliding;
      case 'Aire acondicionado':
        return Icons.ac_unit;
      case 'Levantavidrios eléctricos':
        return Icons.electric_car;
      case 'Cierre centralizado':
        return Icons.lock;
      case 'Dirección Asistida':
        return Icons.directions_car_filled;
      case 'Air bag':
        return Icons.no_crash;
      case '1 maleta(s) grande(s)':
        return Icons.work;
      case '2 maleta(s) pequeña(s)':
        return Icons.work_outline;
      case '6 personas':
        return Icons.group;
      default:
        return Icons.info;
    }
  }
}
