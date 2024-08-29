import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:autos/View/Proveedor/Reservas_Aprobadas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/AlquilerModel.dart';
import 'package:autos/Servicios/alquilerService.dart';
import 'package:autos/Servicios/LoginService.dart';
import 'dart:convert';

class VerSolicitudesAlquiler extends StatefulWidget {
  const VerSolicitudesAlquiler({super.key});

  @override
  State<VerSolicitudesAlquiler> createState() => _VerSolicitudesAlquilerState();
}

class _VerSolicitudesAlquilerState extends State<VerSolicitudesAlquiler> {
  final AlquilerService _alquilerService = AlquilerService();

  List<Alquiler> alquileres = [];

  @override
  void initState() {
    super.initState();
    _fetchData(); // Cargar los datos al iniciar
  }

  Future<void> _fetchData() async {
    List<Alquiler> fetchedAlquileres = await getAlquileres();
    setState(() {
      alquileres = fetchedAlquileres;
    });
  }

  Future<Map<String, dynamic>> _fetchAutoAndUserById(String idAlquiler) async {
    DocumentSnapshot alquilerSnapshot =
        await FirebaseFirestore.instance.collection('alquiler').doc(idAlquiler).get();

    if (alquilerSnapshot.exists) {
      String autoID = alquilerSnapshot['autoID'];
      String usuarioID = alquilerSnapshot['usuarioID'];

      Auto? auto = await getAutoById(int.parse(autoID));
      LoginModel? user = await LoginService().getUserById(usuarioID);

      return {'auto': auto, 'user': user};
    } else {
      return {'auto': null, 'user': null};
    }
  }

  void _cambiarEstadoAlquiler(String idAlquiler, bool nuevoEstado) async {
    await _alquilerService.editarEstadoAlquiler(idAlquiler, nuevoEstado);
    _fetchData(); // Refresca la lista de alquileres después de cambiar el estado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitudes de Alquiler'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData, // Llama a la función que recarga los datos
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Número de columnas en la cuadrícula
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.8, // Ajusta el aspecto de los elementos
          ),
          itemCount: alquileres.length,
          itemBuilder: (context, index) {
            Alquiler alquiler = alquileres[index];

            return FutureBuilder<Map<String, dynamic>>(
              future: _fetchAutoAndUserById(alquiler.id_alquiler),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('Datos no disponibles'));
                }

                Auto? auto = snapshot.data!['auto'];
                LoginModel? user = snapshot.data!['user'];

                if (auto == null || user == null) {
                  return const Center(child: Text('Datos no disponibles'));
                }

                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Detalles de la Solicitud'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (auto.imageBase64.isNotEmpty)
                                Image.memory(
                                  base64Decode(auto.imageBase64),
                                  fit: BoxFit.cover,
                                )
                              else
                                Image.asset(
                                  'assets/images/buggati.jpg', // Imagen por defecto
                                  fit: BoxFit.cover,
                                ),
                              const SizedBox(height: 10),
                              Text('Usuario: ${user.nombre} ${user.apellido}'),
                              Text('Teléfono: ${user.telefono}'),
                              Text('Auto: ${auto.marca}'),
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                _cambiarEstadoAlquiler(alquiler.id_alquiler, true); // Cambia el estado a true
                                Navigator.of(context).pop(); // Cierra el diálogo
                              },
                              child: const Text('Aceptar', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _cambiarEstadoAlquiler(alquiler.id_alquiler, false); // Cambia el estado a false
                                Navigator.of(context).pop(); // Cierra el diálogo
                              },
                              child: const Text('Rechazar', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Cierra el diálogo sin cambiar el estado
                              },
                              child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colors.yellow.shade700,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Bordes redondeados
                          child: Container(
                            height: 120, // Ajusta la altura según tus necesidades
                            width: double.infinity, // Ocupa todo el ancho disponible
                            child: auto.imageBase64.isNotEmpty
                                ? Image.memory(
                                    base64Decode(auto.imageBase64),
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/buggati.jpg', // Imagen por defecto
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            auto.marca,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Text(
                            '${user.nombre} ${user.apellido}', // Nombre y apellido del usuario
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check_circle),
                              color: Colors.green,
                              onPressed: () {
                                _cambiarEstadoAlquiler(alquiler.id_alquiler, true); // Cambia el estado a true
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.cancel),
                              color: Colors.red,
                              onPressed: () {
                                _cambiarEstadoAlquiler(alquiler.id_alquiler, false); // Cambia el estado a false
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AlquileresView()), // Navega a la vista de reservas aprobadas
          );
        },
        child: const Icon(Icons.list_alt), // Ícono para el botón flotante
        backgroundColor: Colors.blue, // Color del botón flotante
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VerSolicitudesAlquiler(),
  ));
}
