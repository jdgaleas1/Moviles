import 'package:autos/View/Proveedor/Reservas_Detalles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/Reserva.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:autos/Servicios/LoginService.dart';
import 'dart:convert';

class ReservasView extends StatefulWidget {
  const ReservasView({Key? key}) : super(key: key);

  @override
  _ReservasViewState createState() => _ReservasViewState();
}

class _ReservasViewState extends State<ReservasView> {
  List<Reserva> reservas = [];

  @override
  void initState() {
    super.initState();
    _fetchReservas();
  }

  Future<void> _fetchReservas() async {
    List<Reserva> fetchedReservas = await getReservas();
    setState(() {
      reservas = fetchedReservas;
    });
  }

  Future<Map<String, dynamic>> _fetchAutoAndUserById(String idAlquiler) async {
    // Primero, obtén el documento de alquiler usando `id_alquiler`
    DocumentSnapshot alquilerSnapshot = await FirebaseFirestore.instance.collection('alquiler').doc(idAlquiler).get();

    if (alquilerSnapshot.exists) {
      String autoID = alquilerSnapshot['autoID'];
      String usuarioID = alquilerSnapshot['usuarioID'];

      // Ahora, usa esos IDs para obtener el auto y el usuario
      Auto? auto = await getAutoById(int.parse(autoID));
      LoginModel? user = await LoginService().getUserById(usuarioID);

      return {'auto': auto, 'user': user};
    } else {
      // Si no existe el documento de alquiler, retorna null para ambos
      return {'auto': null, 'user': null};
    }
  }

  void _showDetails(Reserva reserva, Auto auto) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ReservaDetailSheet(auto: auto, reserva: reserva);
      },
    );
  }

  String _getFormattedDuration(DateTime fechaIni, DateTime fechaFin) {
    Duration duration = fechaFin.difference(fechaIni);

    if (duration.inDays >= 7) {
      int weeks = duration.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'semana' : 'semanas'}';
    } else if (duration.inDays >= 1) {
      return '${duration.inDays} ${duration.inDays == 1 ? 'día' : 'días'}';
    } else {
      return '${duration.inHours} ${duration.inHours == 1 ? 'hora' : 'horas'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas Aprobadas'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemCount: reservas.length,
        itemBuilder: (context, index) {
          Reserva reserva = reservas[index];

          return FutureBuilder<Map<String, dynamic>>(
            future: _fetchAutoAndUserById(reserva.id_alquiler),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error al cargar los datos'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('Datos no disponibles'));
              }

              Auto? auto = snapshot.data!['auto'];
              LoginModel? user = snapshot.data!['user'];

              if (auto == null || user == null) {
                return const Center(child: Text('Datos no disponibles'));
              }

              return GestureDetector(
                onTap: () {
                  _showDetails(reserva, auto);
                },
                child: Card(
                  margin: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: auto.imageBase64.isNotEmpty
                            ? Image.memory(
                                base64Decode(auto.imageBase64),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/buggati.jpg',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Auto: ${auto.marca}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Reservado por: ${user.nombre} ${user.apellido}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Duración: ${_getFormattedDuration(reserva.fechaIni, reserva.fechaFin)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
