// tab_todos.dart
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/animacionFrontal.dart';
import 'package:autos/View/Cliente/Tabs/detallesAlquiler.dart';
import 'package:flutter/material.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({super.key});

  @override
  _TodosTabState createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  List<bool> isFlipped = List.generate(10, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(7),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          childAspectRatio: 0.7,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return AnimarTab(
            isFlipped: isFlipped[index],
            frontWidget: buildFrontView(index),
            backWidget: buildBackView(index),
            onFlip: () => setState(() {
              isFlipped[index] = !isFlipped[index];
            }),
          );
        },
      ),
    );
  }

  Widget buildFrontView(int index) {
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
                              //backgroundColor: Theme.of(context).colorScheme.secondary),
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

  Widget buildBackView(int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: Text(
          'Detalles adicionales del carro $index',
          style: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
