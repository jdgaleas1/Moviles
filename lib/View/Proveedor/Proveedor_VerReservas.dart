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
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas en la cuadrícula
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.8, // Ajusta el aspecto de los elementos
        ),
        itemCount: 5, // Número de solicitudes en la lista
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Detalles de la Solicitud $index'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/bugatti-chiron-pur-sport-grand-prix-soymotor.jpg',
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 10),
                        Text('Usuario $index'),
                        Text('Fecha de Reserva: 2024-07-22'),
                        Text('Duración: 3 días'),
                        Text('Auto: Marca del Auto $index'),
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // Acción para aceptar la solicitud
                          Navigator.of(context).pop();
                        },
                        child: const Text('Aceptar',style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Acción para rechazar la solicitud
                          Navigator.of(context).pop();
                        },
                        child: const Text('Rechazar',style: TextStyle(color: Colors.white)),
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
                    child: Image.asset(
                      'assets/images/bugatti-chiron-pur-sport-grand-prix-soymotor.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Marca del Auto $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text('Duración: 3 días', style: const TextStyle(fontSize: 12)),
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
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VerSolicitudesReserva(),
  ));
}
