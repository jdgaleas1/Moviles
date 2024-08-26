import 'package:autos/Model/Reserva.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

class VerSolicitudesReserva extends StatefulWidget {
  const VerSolicitudesReserva({super.key});

  @override
  State<VerSolicitudesReserva> createState() => _VerSolicitudesReservaState();
}

class _VerSolicitudesReservaState extends State<VerSolicitudesReserva> {
  List<Reserva> reservas = [];
  List<Auto?> autos = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Cargar los datos al iniciar
  }

  Future<void> _fetchData() async {
    List<Reserva> fetchedReservas = await getReservas();  // Llama al controlador de reservas
    List<Auto?> fetchedAutos = [];

    for (var reserva in fetchedReservas) {
      Auto? auto = await getAutoById(reserva.idaut);  // Llama al controlador de autos
      fetchedAutos.add(auto);
    }

    setState(() {
      reservas = fetchedReservas;
      autos = fetchedAutos;
    });
  }

  String _calculateDuration(Reserva reserva) {
    Duration duration = reserva.fechaFin.difference(reserva.fechaIni);
    if (duration.inDays >= 1) {
      return '${duration.inDays} días';
    } else {
      return '${duration.inHours} horas';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Reserva'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas en la cuadrícula
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8, // Ajusta el aspecto de los elementos
        ),
        itemCount: reservas.length,
        itemBuilder: (context, index) {
          Reserva reserva = reservas[index];
          Auto? auto = autos[index];
          String duration = _calculateDuration(reserva);

          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Detalles de la Solicitud'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (auto != null) Image.network(
                          auto.imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/buggati.jpg', // Imagen por defecto
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        Text('Usuario: ${reserva.idusu}'),
                        Text('Fecha de Reserva: ${reserva.fechaIni}'),
                        Text('Duración: $duration'),
                        if (auto != null) Text('Auto: ${auto.marca}'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción para aceptar la solicitud
                          Navigator.of(context).pop();
                        },
                        child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para rechazar la solicitud
                          Navigator.of(context).pop();
                        },
                        child: const Text('Rechazar', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                      ),
                    ],
                  );
                },
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: Colors.yellow.shade700,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: auto != null
                        ? Image.network(
                            auto.imagePath,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/buggati.jpg', // Imagen por defecto
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.asset(
                            'assets/images/buggati.jpg', // Imagen por defecto si el auto es null
                            fit: BoxFit.cover,
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(auto?.marca ?? 'Auto no disponible', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('Duración: $duration', style: const TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VerSolicitudesReserva(),
  ));
}
