import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autos/Model/alquilerModel.dart'; 

class AlquilerService {
  final CollectionReference _alquilerCollection = FirebaseFirestore.instance.collection('alquiler');

  Future<void> agregarAlquiler(Alquiler alquiler) async {
    try {
      // Agregar el documento a Firestore y obtener la referencia del documento generado
      DocumentReference docRef = await _alquilerCollection.add(alquiler.toMap());

      // Obtener el ID generado por Firestore
      String generatedId = docRef.id;

      // Si necesitas guardar el ID en el modelo o realizar alguna acción adicional con el ID generado,
      // puedes hacerlo aquí.
      print("ID generado: $generatedId");
    } catch (e) {
      throw Exception('Error al agregar el alquiler: $e');
    }
  }
}
