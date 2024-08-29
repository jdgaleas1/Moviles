import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/alquilerService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:autos/Model/alquilerModel.dart';
import 'dart:convert'; // Import necesario para base64Decode

final String Saludos = "Saludos! me interesa alquilar el coche";
final double precio = 59.99; // Precio del alquiler por día
final String phoneNumber = ''; // Número de WhatsApp en formato internacional
final String marca = ''; // Número de WhatsApp en formato internacional
final String placa = ''; // Número de WhatsApp en formato internacional
final int identificador = 0; // Número de WhatsApp en formato internacional

class ClienteReservas extends StatefulWidget {
  ClienteReservas({super.key});

  @override
  State<ClienteReservas> createState() => _ClienteReservasState();
}

class _ClienteReservasState extends State<ClienteReservas> {
  List<Map<String, dynamic>> _reservasConDatosCompletos = [];
  final AlquilerService _alquilerService = AlquilerService();

  @override
  void initState() {
    super.initState();
    loadReservas();
  }

  Future<void> loadReservas() async {
    try {
      List<Alquiler> reservasCargadas = await _alquilerService.obtenerAlquileres();

      // Crear una lista temporal que almacene los alquileres con los datos completos
      List<Map<String, dynamic>> reservasConDatosCompletos = [];

      for (var reserva in reservasCargadas) {
        // Obtener datos del auto
        var autoSnapshot = await FirebaseFirestore.instance
            .collection('auto')
            .doc(reserva.autoID)
            .get();
        var auto = Auto.fromFirestore(autoSnapshot.data() as Map<String, dynamic>);

        // Obtener datos del usuario
        var usuarioSnapshot = await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(reserva.usuarioID)
            .get();
        var usuario = LoginModel.fromFirestore(
            usuarioSnapshot.data() as Map<String, dynamic>, reserva.usuarioID);

        // Crear un mapa que contenga la reserva, auto, y usuario
        reservasConDatosCompletos.add({
          'reserva': reserva,
          'auto': auto,
          'usuario': usuario,
        });
      }

      setState(() {
        _reservasConDatosCompletos = reservasConDatosCompletos; // Nueva lista con datos completos
      });
    } catch (e) {
      print('Error al cargar las reservas: $e');
    }
  }

  void cancelarReserva(String id) async {
    try {
      // Llama al servicio para eliminar la reserva de la base de datos
      await _alquilerService.eliminarAlquiler(id);
      
      // Remueve la reserva de la lista local
      setState(() {
        _reservasConDatosCompletos.removeWhere((reservaMap) => reservaMap['reserva'].id_alquiler == id);
      });
    } catch (e) {
      print('Error al cancelar la reserva: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cancelar la reserva: $e')),
      );
    }
  }

  void vistaModalReservasDetalles(Map<String, dynamic> reservaMap) {
    final Alquiler reserva = reservaMap['reserva'];
    final Auto auto = reservaMap['auto'];
    final LoginModel usuario = reservaMap['usuario']; // Cambia 'usuarios' por 'usuario'

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
                auto.imageBase64 != null && auto.imageBase64!.isNotEmpty
                    ? Image.memory(base64Decode(auto.imageBase64!), fit: BoxFit.cover)
                    : Image.asset('assets/images/car.png', fit: BoxFit.cover),
                SizedBox(height: 10),
                Text('Codigo identificador: ${auto.id?? identificador}'), 
                Text('Estado: ${reserva.estado ? "Confirmado" : "En espera"}'),
                Text('Auto: ${auto.marca?? marca}\nPlaca:${auto.placa ?? placa}'),
                Text('Disponible: ${reserva.disponible ? "Sí" : "No"}'),
                Text('Precio por día: \$${auto.precio ?? precio}'), // Precio
                Text('Proveedor: 0${usuario.telefono ?? phoneNumber}'), // Número del proveedor
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: reserva.estado
                  ? () {
                      _contactarPorWhatsApp(usuario.telefono.toString(), auto.precio, auto.marca, auto.placa, auto.id);
                    }
                  : null, // Si el estado es false, el botón estará deshabilitado
              child: Text(
                'Contactar',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: reserva.estado
                    ? Color.fromARGB(255, 1, 46, 65)
                    : Colors.grey, // Cambia el color si está deshabilitado
              ),
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

  Future<void> _contactarPorWhatsApp(String? telefono, double? precio, String? marca, String? placa, int id ) async {
    try {
      String? response = await FlutterShareMe().shareWhatsAppPersonalMessage(
        message: '$Saludos marca($marca) placa($placa) \$$precio con el identificador: $identificador' ,
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
        child: _reservasConDatosCompletos.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: _reservasConDatosCompletos.length,
                itemBuilder: (context, index) {
                  final reservaMap = _reservasConDatosCompletos[index];
                  final Alquiler reserva = reservaMap['reserva'];
                  final Auto auto = reservaMap['auto'];

                  return GestureDetector(
                    onTap: () => vistaModalReservasDetalles(reservaMap),
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
                          Text('Auto: ${auto.marca}'),
                          SizedBox(height: 10),
                          Text('Precio: \$${auto.precio ?? precio}'),
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
