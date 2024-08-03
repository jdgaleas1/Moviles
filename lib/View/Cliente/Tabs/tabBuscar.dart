import 'package:autos/View/Cliente/Tabs/vistaTraseraCarta.dart';
import 'package:flutter/material.dart';
import 'package:autos/View/Cliente/Tabs/VistaDetallesAlquiler.dart';
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/animacionFrontal.dart';

class BuscarTab extends StatefulWidget {
  const BuscarTab({super.key});

  @override
  _BuscarTabState createState() => _BuscarTabState();
}

class _BuscarTabState extends State<BuscarTab> {
  List<bool> isFlipped = List.generate(10, (_) => false);

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
            child: GridView.builder(
              padding: const EdgeInsets.all(7),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio: 0.7,
              ),
              itemCount: 3,
              itemBuilder: (context, index) {
                return AnimarTab(
                  isFlipped: isFlipped[index],
                  frontWidget: buildFrontView(context, index),
                  backWidget: buildBackView(index),
                  onFlip: () => setState(() {
                    isFlipped[index] = !isFlipped[index];
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFrontView(BuildContext context, int index) {
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
                  Text('Nombre del carro $index',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  const Text('En terminal . UIO',
                      style: TextStyle(fontSize: 10)),
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
                              backgroundColor: Color.fromARGB(255, 1, 46, 65)),
                          child: const Text('RESERVAR',
                              style: TextStyle(fontSize: 5)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                        ),
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
