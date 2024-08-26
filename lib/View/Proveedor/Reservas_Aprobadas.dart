import 'package:autos/View/Proveedor/Reservas_Detalles.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/Reserva.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart'; // Asegúrate de importar el modelo de usuario
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:autos/Servicios/LoginService.dart'; // Importa el servicio de login
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

  Future<Auto?> _fetchAutoById(int idaut) async {
    return await getAutoById(idaut);
  }

  Future<LoginModel?> _fetchUserById(String idusu) async {
    return await LoginService().getUserById(idusu);
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
          return FutureBuilder<Auto?>(
            future: _fetchAutoById(reserva.idaut),
            builder: (context, autoSnapshot) {
              if (autoSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (autoSnapshot.hasError) {
                return const Center(child: Text('Error al cargar el auto'));
              } else if (!autoSnapshot.hasData || autoSnapshot.data == null) {
                return const Center(child: Text('Auto no disponible'));
              }

              Auto auto = autoSnapshot.data!;

              return FutureBuilder<LoginModel?>(
                future: _fetchUserById(reserva.idusu),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (userSnapshot.hasError) {
                    return const Center(
                        child: Text('Error al cargar el usuario'));
                  } else if (!userSnapshot.hasData ||
                      userSnapshot.data == null) {
                    return const Center(child: Text('Usuario no disponible'));
                  }

                  LoginModel user = userSnapshot.data!;

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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}
