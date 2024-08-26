import 'package:autos/View/Proveedor/Agregar_Auto.dart';
import 'package:autos/View/Proveedor/Editar_Auto.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List autos = snapshot.data!;
            return RefreshIndicator(
              onRefresh: _refreshAutos,  // Llamado cuando se desliza hacia abajo
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Número de columnas en la cuadrícula
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: 1,
                ),
                itemCount: autos.length, // Número de autos en la lista
                itemBuilder: (context, index) {
                  Auto auto = autos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AutoDetailScreen(auto: auto),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.file(
                              File(auto.imagePath),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/buggati.jpg',
                                  fit: BoxFit.cover,
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
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarAuto()),
          );
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del ${auto.marca}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              File(auto.imagePath),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/buggati.jpg',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                );
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
            Text('Ciudad: ${auto.ciudad}'), // Nueva línea para mostrar la ciudad
            const SizedBox(height: 5),
            Text('Provincia: ${auto.provincia}'), // Nueva línea para mostrar la provincia
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditarAuto(auto: auto)),
                    );
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
                          content: const Text(
                              "¿Estás seguro de que deseas eliminar este auto?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); 
                              },
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await eliminarAuto(auto.id).then((_){
                                  Navigator.pop(context);
                                });
                                Navigator.of(context).pop();
                              },
                              child: const Text("Eliminar"),
                            ),
                          ],
                        );
                      },
                    );
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
