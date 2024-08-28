import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  int id; 
  DateTime fechaIni; 
  DateTime fechaFin; 
  String id_alquiler;

  Reserva({
    required this.id,
    required this.fechaIni,
    required this.fechaFin,
    required this.id_alquiler,
  });

  factory Reserva.fromFirestore(Map<String, dynamic> data) {
    return Reserva(
      id: (data['id'] as num).toInt(),
      fechaIni: (data['fecha_ini'] != null) ? (data['fecha_ini'] as Timestamp).toDate() : DateTime.now(), // Maneja caso nulo
      fechaFin: (data['fecha_fin'] != null) ? (data['fecha_fin'] as Timestamp).toDate() : DateTime.now(), // Maneja caso nulo
      id_alquiler: data['id_alquiler'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'id_alquiler': id_alquiler,
    };
  }
}
