import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/VistaDetallesAlquiler.dart';
import 'package:autos/View/Cliente/Tabs/animacionFrontal.dart';
import 'package:autos/View/Cliente/Tabs/vistaTraseraCarta.dart';
import 'package:flutter/material.dart';

class BuscarTab extends StatefulWidget {
  const BuscarTab({super.key});

  @override
  _BuscarTabState createState() => _BuscarTabState();
}

class _BuscarTabState extends State<BuscarTab> {
  late Future<List<Auto>> _autosFuture;

  @override
  void initState() {
    super.initState();
    _autosFuture = getAuto(); // Llama al servicio para obtener los autos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Buscar',
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                filled: true,
                fillColor: Colors.white.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Auto>>(
              future: _autosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay autos disponibles.'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(7),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final auto = snapshot.data![index];
                      final caracteristicas = auto.caracteristicas.split(', '); // Divide las características en una lista

                      return AnimarTab(
                        isFlipped: false,
                        frontWidget: buildFrontView(index, auto),
                        backWidget: buildBackView(caracteristicas), // Usa la función `buildBackView`
                        onFlip: () => setState(() {}),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFrontView(int index, Auto auto) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Image.asset('assets/images/car.png', fit: BoxFit.cover),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre del carro ${auto.marca}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('En terminal . ${auto.ciudad}, ${auto.provincia}',
                      style: const TextStyle(fontSize: 10)),
                  const Text('Política de combust.',
                      style: TextStyle(fontSize: 10)),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DetallesAlquilerPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: const Size(50, 25),
                              backgroundColor: const Color.fromARGB(255, 1, 46, 65)),
                          child: const Text('RESERVAR',
                              style: TextStyle(fontSize: 5)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => NotificationHelper.showAddedNotification(context),
                        color: Colors.grey,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
