import 'package:flutter/material.dart';
import 'package:autos/Model/Reserva.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:autos/Servicios/LoginService.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart'; // Importa el modelo de usuario
import 'dart:convert'; // Import necesario para base64Decode
import 'Reservas_Aprobadas.dart'; // Importa la vista de reservas aprobadas
import 'package:intl/intl.dart';


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
    List<Reserva> fetchedReservas =
        await getReservas(); // Llama al controlador de reservas
    List<Auto?> fetchedAutos = [];

    for (var reserva in fetchedReservas) {
      Auto? auto =
          await getAutoById(reserva.idaut); // Llama al controlador de autos
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

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date);
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

          return FutureBuilder<LoginModel?>(
            future: LoginService()
                .getUserById(reserva.idusu), // Obtén la información del usuario
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (userSnapshot.hasError) {
                return const Center(child: Text('Error al cargar el usuario'));
              } else if (!userSnapshot.hasData || userSnapshot.data == null) {
                return const Center(child: Text('Usuario no disponible'));
              }

              LoginModel user = userSnapshot.data!;

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
                            if (auto != null)
                              auto.imageBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(auto.imageBase64),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/buggati.jpg', // Imagen por defecto
                                      fit: BoxFit.cover,
                                    ),
                            const SizedBox(height: 10),
                            Text('Usuario: ${user.nombre} ${user.apellido}'),
                            Text(
                                'Teléfono: ${user.telefono}'), // Muestra el teléfono en la vista detallada
                            Text(
                                'Fecha de Inicio: ${_formatDate(reserva.fechaIni)}'),
                            Text(
                                'Fecha Final: ${_formatDate(reserva.fechaFin)}'),
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
                            child: const Text('Aceptar',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción para rechazar la solicitud
                              Navigator.of(context).pop();
                            },
                            child: const Text('Rechazar',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar',
                                style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey),
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
                  margin: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            10), // Asegura que los bordes sean redondeados
                        child: Container(
                          height: 120, // Ajusta la altura según tus necesidades
                          width: double
                              .infinity, // Asegura que ocupe todo el ancho disponible
                          child: auto != null
                              ? auto.imageBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(auto.imageBase64),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/buggati.jpg', // Imagen por defecto
                                      fit: BoxFit.cover,
                                    )
                              : Image.asset(
                                  'assets/images/buggati.jpg', // Imagen por defecto si el auto es null
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          auto?.marca ?? 'Auto no disponible',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          '${user.nombre} ${user.apellido}', // Muestra el nombre y apellido del usuario
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: Text('Duración: $duration',
                            style: const TextStyle(fontSize: 12)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check_circle),
                            color: Colors.green,
                            onPressed: () {
                              // Acción para aceptar la solicitud
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                              // Acción para rechazar la solicitud
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ReservasView()), // Navega a la vista de reservas aprobadas
          );
        },
        child: const Icon(Icons.list_alt), // Ícono para el botón flotante
        backgroundColor: Colors.blue, // Color del botón flotante
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VerSolicitudesReserva(),
  ));
}
