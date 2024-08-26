import 'package:autos/View/Proveedor/Agregar_Auto.dart';
import 'package:autos/View/Proveedor/Editar_Auto.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'dart:convert';
import 'dart:typed_data';

class Proveedor extends StatefulWidget {
  const Proveedor({super.key});

  @override
  State<Proveedor> createState() => _ProveedorState();
}

class _ProveedorState extends State<Proveedor> {
  Future<void> _refreshAutos() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Autos'),
      ),
      body: FutureBuilder(
        future: getAuto(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List autos = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshAutos,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1,
                ),
                itemCount: autos.length,
                itemBuilder: (context, index) {
                  Auto auto = autos[index];

                  // Decodificar la imagen de base64 a bytes
                  Uint8List imageBytes = base64Decode(auto.imageBase64);

                  return GestureDetector(
                    onTap: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AutoDetailScreen(auto: auto),
                        ),
                      );
                      if (result == true) {
                        _refreshAutos();
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.memory(
                              imageBytes,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Text('Error al cargar la imagen'),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(auto.marca, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarAuto()),
          );
          if (result == true) {
            _refreshAutos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AutoDetailScreen extends StatelessWidget {
  final Auto auto;

  const AutoDetailScreen({required this.auto});

  @override
  Widget build(BuildContext context) {
    Uint8List imageBytes = base64Decode(auto.imageBase64);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del ${auto.marca}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.memory(
              imageBytes,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Error al cargar la imagen'));
              },
            ),
            const SizedBox(height: 10),
            Text('Marca: ${auto.marca}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text('Placa: ${auto.placa}'),
            const SizedBox(height: 5),
            Text('Descripción: ${auto.descripcion}'),
            const SizedBox(height: 5),
            Text('Características: ${auto.caracteristicas}'),
            const SizedBox(height: 5),
            Text('Precio: \$${auto.precio}'),
            const SizedBox(height: 5),
            Text('Ciudad: ${auto.ciudad}'),
            const SizedBox(height: 5),
            Text('Provincia: ${auto.provincia}'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditarAuto(auto: auto)),
                    );
                    if (result == true) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Confirmar eliminación"),
                          content: const Text("¿Estás seguro de que deseas eliminar este auto?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); 
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await eliminarAuto(auto.id).then((_) {
                                  Navigator.pop(context, true);
                                });
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    ).then((result) {
                      if (result == true) {
                        Navigator.pop(context, true);
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
