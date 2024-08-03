import 'package:flutter/material.dart';

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

  void cancelarReserva(int id) {
    setState(() {
      _reservas.removeWhere((reserva) => reserva.id == id);
    });
  }

  void vistaModalReservasDetalles(Reserva reserva) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(reserva.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text('Detalles de la reserva', style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Cancelar Reserva',
                                style: TextStyle(color: Colors.white),),
                
                onPressed: () {
                  cancelarReserva(reserva.id); // Elimina la reserva de la lista
                  Navigator.pop(context); // Cierra la ventana modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 242, 117, 8),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                          Icon(Icons.calendar_today, size: 40, color: Theme.of(context).primaryColor),
                          SizedBox(height: 10),
                          Text(reserva.title, style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
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
