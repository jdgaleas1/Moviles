import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AlquilerModel.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/alquilerService.dart';
import 'package:autos/Servicios/LoginService.dart';
import 'dart:convert';

class AlquileresView extends StatefulWidget {
  const AlquileresView({Key? key}) : super(key: key);

  @override
  _AlquileresViewState createState() => _AlquileresViewState();
}

class _AlquileresViewState extends State<AlquileresView> {
  final AlquilerService _alquilerService = AlquilerService();
  List<Alquiler> alquileres = [];

  @override
  void initState() {
    super.initState();
    _fetchAlquileres();
  }

  Future<void> _fetchAlquileres() async {
    List<Alquiler> fetchedAlquileres = await getAlquileresConEstadoTrue();
    setState(() {
      alquileres = fetchedAlquileres;
    });
  }

  Future<Auto?> _fetchAutoById(int idaut) async {
    return await getAutoById(idaut);
  }

  Future<LoginModel?> _fetchUserById(String idusu) async {
    return await LoginService().getUserById(idusu);
  }

  void _showDetails(Alquiler alquiler, Auto auto, LoginModel user) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AlquilerDetailSheet(auto: auto, user: user);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alquileres Aprobados'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchAlquileres, // Llama a la función que recarga los datos
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemCount: alquileres.length,
          itemBuilder: (context, index) {
            Alquiler alquiler = alquileres[index];
            return FutureBuilder<Auto?>(
              future: _fetchAutoById(int.parse(alquiler.autoID)),
              builder: (context, autoSnapshot) {
                if (autoSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (autoSnapshot.hasError) {
                  return const Center(child: Text('Error al cargar el auto'));
                } else if (!autoSnapshot.hasData || autoSnapshot.data == null) {
                  return const Center(child: Text('Auto no disponible'));
                }

                Auto auto = autoSnapshot.data!;

                return FutureBuilder<LoginModel?>(
                  future: _fetchUserById(alquiler.usuarioID),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (userSnapshot.hasError) {
                      return const Center(
                          child: Text('Error al cargar el usuario'));
                    } else if (!userSnapshot.hasData ||
                        userSnapshot.data == null) {
                      return const Center(child: Text('Usuario no disponible'));
                    }

                    LoginModel user = userSnapshot.data!;

                    return GestureDetector(
                      onTap: () {
                        _showDetails(alquiler, auto, user);
                      },
                      child: Card(
                        margin: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: auto.imageBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(auto.imageBase64),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/buggati.jpg',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Auto: ${auto.marca}',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Reservado por: ${user.nombre} ${user.apellido}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AlquilerDetailSheet extends StatelessWidget {
  final Auto auto;
  final LoginModel user;

  const AlquilerDetailSheet({required this.auto, required this.user});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1.0, // Ocupa el 100% del ancho disponible
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Detalles del Auto',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Marca: ${auto.marca}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Placa: ${auto.placa}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Descripción: ${auto.descripcion}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Precio: \$${auto.precio}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text(
              'Datos del Usuario',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text('Nombre: ${user.nombre} ${user.apellido}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text('Teléfono: ${user.telefono}', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
