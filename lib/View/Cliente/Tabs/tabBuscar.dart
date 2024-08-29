import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:autos/View/Cliente/Tabs/VistaDetallesAlquiler.dart';
import 'package:autos/View/Cliente/Tabs/animacionFrontal.dart';
import 'package:autos/View/Cliente/Tabs/vistaTraseraCarta.dart';

class BuscarTab extends StatefulWidget {
  const BuscarTab({super.key});

  @override
  _BuscarTabState createState() => _BuscarTabState();
}

class _BuscarTabState extends State<BuscarTab> {
  late Future<List<Auto>> _autosFuture;
  List<Auto> _allAutos = [];
  List<Auto> _filteredAutos = [];
  String _searchQuery = '';
  String _selectedFilter = 'Marca';
  bool _isAscending = true;
  Map<int, bool> _flippedCards = {};

  @override
  void initState() {
    super.initState();
    _autosFuture = getAuto();
    _autosFuture.then((autos) {
      setState(() {
        _allAutos = autos;
        _filteredAutos = autos;
        _sortAutos();
      });
    });
  }

  void _filterAutos(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      _filteredAutos = _allAutos.where((auto) {
        return auto.marca.toLowerCase().contains(_searchQuery) ||
            auto.ciudad.toLowerCase().contains(_searchQuery) ||
            auto.provincia.toLowerCase().contains(_searchQuery);
      }).toList();
      _sortAutos();
    });
  }

  void _sortAutos() {
    setState(() {
      _filteredAutos.sort((a, b) {
        int comparison;
        switch (_selectedFilter) {
          case 'Marca':
            comparison = a.marca.compareTo(b.marca);
            break;
          case 'Precio':
            comparison = a.precio.compareTo(b.precio);
            break;
          default:
            comparison = 0;
        }
        return _isAscending ? comparison : -comparison;
      });
    });
  }

  void _toggleFlip(int index) {
    setState(() {
      _flippedCards[index] = !(_flippedCards[index] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Encuentra!!!'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                  child: TextField(
                    onChanged: _filterAutos,
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton<String>(
                      value: _selectedFilter,
                      items: const [
                        DropdownMenuItem(
                          value: 'Marca',
                          child: Text('Marca'),
                        ),
                        DropdownMenuItem(
                          value: 'Precio',
                          child: Text('Precio'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                          _sortAutos();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(_isAscending ? Icons.arrow_upward : Icons.arrow_downward),
                      onPressed: () {
                        setState(() {
                          _isAscending = !_isAscending;
                          _sortAutos();
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Auto>>(
              future: _autosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay autos disponibles.'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(7),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: _filteredAutos.length,
                    itemBuilder: (context, index) {
                      final auto = _filteredAutos[index];
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
          ),
        ],
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
                              MaterialPageRoute(builder: (context) => DetallesAlquilerPage(auto: auto)),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(50, 25),
                            backgroundColor: const Color.fromARGB(255, 1, 46, 65),
                          ),
                          child: const Text('RESERVAR', style: TextStyle(fontSize: 5)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => NotificationHelper.showAddedNotification(context),
                        color: Colors.grey,
                      ),
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

  Widget buildBackView(List<String> caracteristicas) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: caracteristicas.length,
        itemBuilder: (context, index) {
          return Text(caracteristicas[index]);
        },
      ),
    );
  }
}
