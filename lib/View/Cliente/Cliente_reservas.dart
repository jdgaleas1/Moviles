import 'package:autos/Servicios/alquilerService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:autos/Model/alquilerModel.dart';
import 'dart:convert'; // Import necesario para base64Decode

final String Saludos = "Saludos! me interesa alquilar el coche";
final String message = 'Gracias';
final double precio = 59.99; // Precio del alquiler por día
final String phoneNumber = '593 96 224 0716'; // Número de WhatsApp en formato internacional

class ClienteReservas extends StatefulWidget {
  ClienteReservas({super.key});

  @override
  State<ClienteReservas> createState() => _ClienteReservasState();
}

class _ClienteReservasState extends State<ClienteReservas> {
  List<Alquiler> _reservas = [];
  final AlquilerService _alquilerService = AlquilerService();

  @override
  void initState() {
    super.initState();
    loadReservas();
  }

  Future<void> loadReservas() async {
    try {
      _reservas = await _alquilerService.obtenerAlquileres();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error al cargar las reservas: $e');
    }
  }

  void cancelarReserva(String id) {
    setState(() {
      _reservas.removeWhere((reserva) => reserva.id_alquiler == id);
    });
  }

  void vistaModalReservasDetalles(Alquiler reserva) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.grey),
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el diálogo
                },
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Detalles Reserva ${reserva.id_alquiler}',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // Mostrar la imagen del auto si está disponible en base64 o mostrar una imagen por defecto
                reserva.imageBase64 != null && reserva.imageBase64!.isNotEmpty
                    ? Image.memory(base64Decode(reserva.imageBase64!), fit: BoxFit.cover)
                    : Image.asset('assets/images/car.png', fit: BoxFit.cover),
                SizedBox(height: 10),
                Text('Estado: ${reserva.estado ? "Confirmado" : "En espera"}'),
                Text('Auto ID: ${reserva.autoID}'),
                Text('Usuario ID: ${reserva.usuarioID}'),
                Text('Disponible: ${reserva.disponible ? "Sí" : "No"}'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _contactarPorWhatsApp();
              },
              child: Text(
                'Contactar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 46, 65)),
            ),
            ElevatedButton(
              onPressed: () {
                cancelarReserva(reserva.id_alquiler);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text(
                'Rechazar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _contactarPorWhatsApp() async {
    try {
      String? response = await FlutterShareMe().shareWhatsAppPersonalMessage(
        message: '$message $Saludos Alquiler: \$$precio',
        phoneNumber: phoneNumber,
      );
      if (response == 'success') {
        print('Mensaje enviado correctamente');
      } else {
        print('Error al enviar mensaje: $response');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir WhatsApp: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Reservas'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _reservas.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: _reservas.length,
                itemBuilder: (context, index) {
                  final reserva = _reservas[index];
                  return GestureDetector(
                    onTap: () => vistaModalReservasDetalles(reserva),
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.calendar_today,
                              size: 40, color: Theme.of(context).primaryColor),
                          SizedBox(height: 10),
                          Text('Auto ID: ${reserva.autoID}',
                              style: TextStyle(fontSize: 18, color: Colors.black),
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
