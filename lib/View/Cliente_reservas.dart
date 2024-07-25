import 'package:flutter/material.dart';

class ClienteReservas extends StatefulWidget {
  const ClienteReservas({super.key});

  @override
  State<ClienteReservas> createState() => _ClienteReservasState();
}

class _ClienteReservasState extends State<ClienteReservas> {
  List<Reserva> _reservas = [];

  loadReservas() async {
    // Simulación de la carga de datos
    await Future.delayed(const Duration(seconds: 2));
    _reservas = [
      Reserva(id: 1, title: "Reserva 1"),
      Reserva(id: 2, title: "Reserva 2"),
      Reserva(id: 3, title: "Reserva 3"),
      Reserva(id: 4, title: "Reserva 4"),
      Reserva(id: 5, title: "Reserva 5"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Reservas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _reservas.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: _reservas.length,
                itemBuilder: (context, index) {
                  final reserva = _reservas[index];
                  return GestureDetector(
                    onTap: () {
                      // Acción al hacer clic en una reserva
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 40,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            reserva.title,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
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
