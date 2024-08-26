import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/Reserva.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/LoginService.dart'; // Asegúrate de importar el servicio de login

class ReservaDetailSheet extends StatelessWidget {
  final Auto auto;
  final Reserva reserva;

  const ReservaDetailSheet({Key? key, required this.auto, required this.reserva}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModel?>(
      future: LoginService().getUserById(reserva.idusu), // Obtén la información del usuario por ID
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error al cargar los datos del usuario')); // Muestra un mensaje de error
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('Usuario no encontrado')); // Muestra un mensaje si no se encuentra el usuario
        }

        // Una vez que los datos del usuario están disponibles, muestra los detalles
        LoginModel user = snapshot.data!;
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
                    style: Theme.of(context).textTheme.headline6,
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
