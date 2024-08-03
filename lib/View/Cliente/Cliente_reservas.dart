import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

final String Saludos = "Saludos! me interesa el coche - nombre: -----------";
final String message = 'Gracias';
final double precio = 59.99; // Precio del alquiler por día
final String phoneNumber = '593 96 224 0716'; // Número de WhatsApp en formato internacional (ejemplo: 1234567890)

class ClienteReservas extends StatefulWidget {
  ClienteReservas({super.key});

  @override
  State<ClienteReservas> createState() => _ClienteReservasState();
}

class _ClienteReservasState extends State<ClienteReservas> {
  List<Reserva> _reservas = [];

  void loadReservas() async {
    await Future.delayed(Duration(seconds: 1));
    _reservas = [
      Reserva(id: 1, title: "Carro 1"),
      Reserva(id: 2, title: "Carro 2"),
      Reserva(id: 3, title: "Carro 3"),
      Reserva(id: 4, title: "Carro 4"),
      Reserva(id: 5, title: "Carro 5"),
    ];

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadReservas();
  }

  void cancelarReserva(int id) {
    setState(() {
      _reservas.removeWhere((reserva) => reserva.id == id);
    });
  }

  void vistaModalReservasDetalles(Reserva reserva) {
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
                  'Detalles Reserva ${reserva.id}',
                  style: TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Image.asset(
                  'assets/images/car.png', // Asegúrate de tener esta imagen en tus assets
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text('Estado: En espera'),
                Text('Fecha de Reserva: 2024-07-22'), // Asumiendo una fecha estática
                Text('Duración: 3 días'), // Asumiendo una duración estática
                Text('Auto: ${reserva.title}'),
                SizedBox(height: 10),
                Text('Estado: En espera'),
                Text('Fecha de Reserva: 2024-07-22'), // Asumiendo una fecha estática
                Text('Duración: 3 días'), // Asumiendo una duración estática
                Text('Auto: ${reserva.title}'),
                SizedBox(height: 10),
                Text('Estado: En espera'),
                Text('Fecha de Reserva: 2024-07-22'), // Asumiendo una fecha estática
                Text('Duración: 3 días'), // Asumiendo una duración estática
                Text('Auto: ${reserva.title}'),
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
                  color: Colors.white, // Establece el color del texto aquí
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 1, 46, 65)),
            ),
            ElevatedButton(
              onPressed: () {
                cancelarReserva(reserva.id);
                Navigator.of(context).pop(); // Cerrar el diálogo
              },
              child: Text(
                'Rechazar',
                style: TextStyle(
                  color: Colors.white, // Establece el color del texto aquí
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
                          Text(reserva.title,
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

class Reserva {
  final int id;
  final String title;

  Reserva({required this.id, required this.title});
}
