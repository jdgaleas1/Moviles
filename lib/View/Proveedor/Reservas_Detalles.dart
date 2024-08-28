import 'package:autos/Servicios/Auto_Service.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/Reserva.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/LoginService.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa Firestore para manejar las consultas

class ReservaDetailSheet extends StatelessWidget {
  final Auto auto;
  final Reserva reserva;

  const ReservaDetailSheet({Key? key, required this.auto, required this.reserva}) : super(key: key);

  Future<Map<String, dynamic>> _fetchAutoAndUserById(String idAlquiler) async {
    // Primero, obtén el documento de alquiler usando `id_alquiler`
    DocumentSnapshot alquilerSnapshot = await FirebaseFirestore.instance.collection('alquiler').doc(idAlquiler).get();

    if (alquilerSnapshot.exists) {
      String autoID = alquilerSnapshot['autoID'];
      String usuarioID = alquilerSnapshot['usuarioID'];

      // Ahora, usa esos IDs para obtener el auto y el usuario
      Auto? auto = await getAutoById(int.parse(autoID));
      LoginModel? user = await LoginService().getUserById(usuarioID);

      return {'auto': auto, 'user': user};
    } else {
      // Si no existe el documento de alquiler, retorna null para ambos
      return {'auto': null, 'user': null};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchAutoAndUserById(reserva.id_alquiler), // Usa el ID del alquiler para obtener auto y usuario
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los datos del alquiler')); // Muestra un mensaje de error
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Alquiler no encontrado')); // Muestra un mensaje si no se encuentra el alquiler
        }

        // Obtén el auto y el usuario de los datos cargados
        Auto? auto = snapshot.data!['auto'];
        LoginModel? user = snapshot.data!['user'];

        if (auto == null || user == null) {
          return const Center(child: Text('Datos no disponibles')); // Maneja el caso en que los datos no estén disponibles
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Detalles de la Reserva',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Marca: ${auto.marca}'),
              Text('Placa: ${auto.placa}'),
              Text('Descripción: ${auto.descripcion}'),
              Text('Características: ${auto.caracteristicas}'),
              Text('Precio: \$${auto.precio}'),
              const SizedBox(height: 10),
              Text('Fecha de Inicio: ${reserva.fechaIni}'),
              Text('Fecha de Fin: ${reserva.fechaFin}'),
              const SizedBox(height: 10),
              Text('Usuario: ${user.nombre} ${user.apellido}'), // Muestra nombre y apellido
              Text('Teléfono: ${user.telefono}'), // Muestra el teléfono del usuario
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
