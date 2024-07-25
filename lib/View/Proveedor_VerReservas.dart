import 'package:flutter/material.dart';

class VerSolicitudesReserva extends StatefulWidget {
  const VerSolicitudesReserva({super.key});

  @override
  State<VerSolicitudesReserva> createState() => _VerSolicitudesReservaState();
}

class _VerSolicitudesReservaState extends State<VerSolicitudesReserva> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Reserva'),
      ),
      body: ListView.builder(
        itemCount: 5, // Número de solicitudes en la lista
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/car_login.jpg'), // Imagen de ejemplo
              ),
              title: Text('Usuario $index'), // Información de ejemplo
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Fecha de Reserva: 2024-07-22'),
                  Text('Duración: 3 días'),
                  Text('Auto: Marca del Auto $index'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
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
