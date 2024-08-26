import 'dart:convert';

import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/VistaDetallesAlquiler.dart';
import 'package:autos/View/Cliente/Tabs/animacionFrontal.dart';
import 'package:autos/View/Cliente/Tabs/vistaTraseraCarta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TodosTab extends StatefulWidget {
  const TodosTab({super.key});

  @override
  _TodosTabState createState() => _TodosTabState();
}

class _TodosTabState extends State<TodosTab> {
  late Future<List<Auto>> _autosFuture;
  Map<int, bool> _flippedCards = {};

  @override
  void initState() {
    super.initState();
    _autosFuture = getAuto(); // Llama al servicio para obtener los autos
  }
    void _toggleFlip(int index) {
    setState(() {
      _flippedCards[index] = !(_flippedCards[index] ?? false);
    });
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Auto>>(
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
                final caracteristicas = auto.caracteristicas.split(', ');

                return AnimarTab(
                  isFlipped: _flippedCards[index] ?? false,
                  frontWidget: buildFrontView(auto),
                  backWidget: buildBackView(caracteristicas),
                  onFlip: () => _toggleFlip(index),
                );
              },
            );
          }
        },
      ),
    );
  }



  Widget buildFrontView(Auto auto) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: auto.imageBase64.isNotEmpty
                ? Image.memory(base64Decode(auto.imageBase64), fit: BoxFit.cover)
                : Image.asset('assets/images/car.png', fit: BoxFit.cover),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Marca: ${auto.marca}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('Ubicación: ${auto.ciudad}, ${auto.provincia}', style: const TextStyle(fontSize: 6)),
                  Text('${auto.precio.toStringAsFixed(2)} us', style: const TextStyle(fontSize: 10)),
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
                          style: ElevatedButton.styleFrom(minimumSize: const Size(50, 25), backgroundColor: Color.fromARGB(255, 1, 46, 65)),
                          child: const Text('RESERVAR', style: TextStyle(fontSize: 5)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {},
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
