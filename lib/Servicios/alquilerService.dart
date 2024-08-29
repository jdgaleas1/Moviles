import 'package:autos/Model/alquilerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlquilerService {
  final CollectionReference _alquilerCollection =
      FirebaseFirestore.instance.collection('alquiler');

  // Obtener lista de alquileres
  Future<List<Alquiler>> getAlquileres() async {
    try {
      QuerySnapshot snapshot = await _alquilerCollection.get();
      return snapshot.docs.map((doc) {
        return Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error al obtener los alquileres: $e');
      return [];
    }
  }

  // Agregar un nuevo alquiler
  Future<void> agregarAlquiler(Alquiler alquiler) async {
    try {
      await _alquilerCollection.add(alquiler.toMap());
      print("Alquiler agregado exitosamente.");
    } catch (e) {
      throw Exception('Error al agregar el alquiler: $e');
    }
  }

  // Obtener alquiler por ID
  Future<Alquiler?> obtenerAlquilerPorId(String idAlquiler) async {
    try {
      DocumentSnapshot docSnapshot = await _alquilerCollection.doc(idAlquiler).get();
      if (docSnapshot.exists) {
        return Alquiler.fromMap(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        print('No se encontró el alquiler con ID: $idAlquiler');
        return null;
      }
    } catch (e) {
      throw Exception('Error al obtener el alquiler: $e');
    }
  }

  // Actualizar el estado del alquiler
  Future<void> editarEstadoAlquiler(String idAlquiler, bool nuevoEstado) async {
    try {
      await _alquilerCollection.doc(idAlquiler).update({
        'estado': nuevoEstado,
      });
      print("Estado del alquiler actualizado exitosamente.");
    } catch (e) {
      throw Exception('Error al actualizar el estado del alquiler: $e');
    }
  }

  // Eliminar un alquiler
  Future<void> eliminarAlquiler(String idAlquiler) async {
    try {
      await _alquilerCollection.doc(idAlquiler).delete();
      print("Alquiler eliminado exitosamente.");
    } catch (e) {
      throw Exception('Error al eliminar el alquiler: $e');
    }
  }

  // Obtener alquileres por estado
  Future<List<Alquiler>> getAlquileresConEstadoTrue() async {
    try {
      QuerySnapshot snapshot = await _alquilerCollection.where('estado', isEqualTo: true).get();
      return snapshot.docs.map((doc) {
        return Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error al obtener los alquileres con estado true: $e');
      return [];
    }
  }
Future<List<Alquiler>> obtenerAlquileres() async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('alquiler').get();
  return querySnapshot.docs.map((doc) {
    return Alquiler.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }).toList();
}

}
