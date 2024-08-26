import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  int id; 
  DateTime fechaIni; 
  DateTime fechaFin; 
  int idaut; 
  String idusu;

  Reserva({
    required this.id,
    required this.fechaIni,
    required this.fechaFin,
    required this.idaut,
    required this.idusu,
  });

  factory Reserva.fromFirestore(Map<String, dynamic> data) {
    return Reserva(
      id: (data['id'] as num).toInt(), 
      fechaIni: (data['fecha_ini'] as Timestamp).toDate(), 
      fechaFin: (data['fecha_fin'] as Timestamp).toDate(), 
      idaut: (data['idaut'] as num).toInt(),
      idusu: data['idusu'] as String,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'idaut': idaut,
      'idusu': idusu,
    };
  }
}
