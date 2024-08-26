import 'package:autos/Model/Reserva.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/Reservas_Service.dart';
import 'package:flutter/material.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert'; // Import necesario para base64Decode

class ReservasView extends StatefulWidget {
  const ReservasView({Key? key}) : super(key: key);

  @override
  _ReservasViewState createState() => _ReservasViewState();
}

class _ReservasViewState extends State<ReservasView> {
  List<Reserva> reservas = [];
  Auto? selectedAuto; // Auto seleccionado para mostrar detalles
  Reserva? selectedReserva; // Reserva seleccionada

  @override
  void initState() {
    super.initState();
    _fetchReservas(); // Cargar las reservas al iniciar
  }

  Future<void> _fetchReservas() async {
    List<Reserva> fetchedReservas =
        await getReservas(); // Función para obtener las reservas desde Firestore
    setState(() {
      reservas = fetchedReservas;
    });
  }

  Future<Auto?> _fetchAutoById(int idaut) async {
    return await getAutoById(idaut); // Función para obtener el auto por id
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservas'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dos columnas
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.75, // Aspecto de las tarjetas
              ),
              itemCount: reservas.length,
              itemBuilder: (context, index) {
                Reserva reserva = reservas[index];
                return GestureDetector(
                  onTap: () async {
                    Auto? auto = await _fetchAutoById(reserva.idaut);
                    setState(() {
                      selectedAuto = auto;
                      selectedReserva = reserva;
                    });
                  },
                  child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: selectedAuto != null &&
                                  selectedReserva == reserva
                              ? selectedAuto!.imageBase64.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(
                                          selectedAuto!.imageBase64),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/images/buggati.jpg', // Imagen por defecto
                                      fit: BoxFit.cover,
                                    )
                              : Container(), // Contenedor vacío para la imagen mientras se carga
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Marca del Auto ${reserva.idaut}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Duración: ${reserva.fechaFin.difference(reserva.fechaIni).inDays} días'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (selectedAuto != null && selectedReserva != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  Text('Detalles de la Reserva:',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 10),
                  Text('Marca: ${selectedAuto!.marca}'),
                  Text('Placa: ${selectedAuto!.placa}'),
                  Text('Descripción: ${selectedAuto!.descripcion}'),
                  Text('Características: ${selectedAuto!.caracteristicas}'),
                  Text('Precio: \$${selectedAuto!.precio}'),
                  //Text('Ciudad: ${selectedAuto!.ciudad}'),
                  //Text('Provincia:${selectedAuto!.provincia}'),
                  const SizedBox(height: 10),
                  Text('Fecha de Inicio: ${selectedReserva!.fechaIni}'),
                  Text('Fecha de Fin: ${selectedReserva!.fechaFin}'),
                  Text('ID del Usuario: ${selectedReserva!.idusu}'),
                  // Muestra el ID del usuario
                ],
              ),
            ),
        ],
      ),
    );
  }
}
