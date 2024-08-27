import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autos/Model/alquilerModel.dart'; 

class AlquilerService {
  final CollectionReference _alquilerCollection = FirebaseFirestore.instance.collection('alquiler');

  Future<void> agregarAlquiler(Alquiler alquiler) async {
    try {
      await _alquilerCollection.add(alquiler.toMap());
    } catch (e) {
      throw Exception('Error al agregar el alquiler: $e');
    }
  }
}
