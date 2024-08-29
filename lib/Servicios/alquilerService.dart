import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:autos/Model/alquilerModel.dart';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';

class AlquilerService {
  final CollectionReference _alquilerCollection =
      FirebaseFirestore.instance.collection('alquiler');
  final CollectionReference _autoCollection =
      FirebaseFirestore.instance.collection('auto');
  final CollectionReference _usuarioCollection =
      FirebaseFirestore.instance.collection('usuarios');

  Future<List<Alquiler>> getAlquileres() async {
    List<Alquiler> _alquileres = [];

    try {
      // Obtiene la colección de alquileres desde Firestore
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('alquiler').get();

      // Mapea los documentos a instancias de Alquiler
      _alquileres = snapshot.docs.map((doc) {
        return Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error al obtener los alquileres: $e');
    }

    return _alquileres;
  }

  Future<void> agregarAlquiler(Alquiler alquiler) async {
    try {
      // Agregar el documento a Firestore y obtener la referencia del documento generado
      DocumentReference docRef =
          await _alquilerCollection.add(alquiler.toMap());

      // Obtener el ID generado por Firestore
      String generatedId = docRef.id;

      // Si necesitas guardar el ID en el modelo o realizar alguna acción adicional con el ID generado,
      // puedes hacerlo aquí.
      print("ID generado: $generatedId");
    } catch (e) {
      throw Exception('Error al agregar el alquiler: $e');
    }
  }

  Future<Map<String, dynamic>> obtenerDatosCompletosAlquiler(
      String autoID, String usuarioID) async {
    try {
      // Obtener los datos del auto
      DocumentSnapshot autoSnapshot = await _autoCollection.doc(autoID).get();
      Auto auto =
          Auto.fromFirestore(autoSnapshot.data() as Map<String, dynamic>);

      // Imprimir los datos del auto para depuración
      print("Datos del Auto:");
      print(auto.toMap());

      // Obtener los datos del usuario
      DocumentSnapshot usuarioSnapshot =
          await _usuarioCollection.doc(usuarioID).get();
      LoginModel usuario = LoginModel.fromFirestore(
          usuarioSnapshot.data() as Map<String, dynamic>, usuarioSnapshot.id);

      // Imprimir los datos del usuario para depuración
      print("Datos del Usuario:");
      print(usuario.toMap());

      // Retornar un mapa con los datos completos del auto y el usuario
      return {
        'auto': auto.toMap(),
        'usuario': usuario.toMap(),
      };
    } catch (e) {
      print('Error al obtener los datos completos del alquiler: $e');
      throw Exception('Error al obtener los datos completos del alquiler: $e');
    }
  }

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

  Future<Alquiler> obtenerAlquilerPorId(String idAlquiler) async {
    try {
      DocumentSnapshot docSnapshot =
          await _alquilerCollection.doc(idAlquiler).get();

      if (docSnapshot.exists) {
        return Alquiler.fromMap(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        throw Exception('El alquiler no existe.');
      }
    } catch (e) {
      throw Exception('Error al obtener el alquiler: $e');
    }
  }

  Future<List<Alquiler>> getAlquileresConEstadoTrue() async {
    List<Alquiler> _alquileres = [];

    try {
      // Realizar la consulta para obtener solo los alquileres con estado true
      QuerySnapshot snapshot =
          await _alquilerCollection.where('estado', isEqualTo: true).get();

      // Convertir los documentos en instancias de Alquiler
      _alquileres = snapshot.docs.map((doc) {
        return Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error al obtener los alquileres con estado true: $e');
    }

    return _alquileres;
  }

Future<List<Alquiler>> obtenerAlquileres() async {
  try {
    QuerySnapshot snapshot = await _alquilerCollection.get();
    List<Alquiler> alquileres = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Obtener el alquiler básico
      Alquiler alquiler = Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);

      // Obtener los datos completos del auto y usuario asociados
      Map<String, dynamic> datosCompletos = await obtenerDatosCompletosAlquiler(alquiler.autoID, alquiler.usuarioID);

      // Crear un nuevo objeto Alquiler con los datos completos
      alquileres.add(Alquiler(
        id_alquiler: alquiler.id_alquiler,
        autoID: alquiler.autoID,
        usuarioID: alquiler.usuarioID,
        disponible: alquiler.disponible,
        estado: alquiler.estado,
        auto: Auto.fromFirestore(datosCompletos['auto']),
        usuario: LoginModel.fromFirestore(datosCompletos['usuario'], alquiler.usuarioID),
      ));
    }

    return alquileres;
  } catch (e) {
    print('Error al obtener los alquileres: $e');
    throw Exception('Error al obtener los alquileres: $e');
  }
}
Future<List<Alquiler>> obtenerAlquileresPorAutoID(String autoID) async {
  try {
    // Consulta para obtener los documentos que coincidan con el autoID dado
    QuerySnapshot snapshot = await _alquilerCollection.where('autoID', isEqualTo: autoID).get();
    List<Alquiler> alquileres = [];

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      // Obtener el alquiler básico
      Alquiler alquiler = Alquiler.fromMap(doc.data() as Map<String, dynamic>, doc.id);

      // Obtener los datos completos del auto y usuario asociados
      Map<String, dynamic> datosCompletos = await obtenerDatosCompletosAlquiler(alquiler.autoID, alquiler.usuarioID);

      // Crear un nuevo objeto Alquiler con los datos completos
      alquileres.add(Alquiler(
        id_alquiler: alquiler.id_alquiler,
        autoID: alquiler.autoID,
        usuarioID: alquiler.usuarioID,
        disponible: alquiler.disponible,
        estado: alquiler.estado,
        auto: Auto.fromFirestore(datosCompletos['auto']),
        usuario: LoginModel.fromFirestore(datosCompletos['usuario'], alquiler.usuarioID),
      ));
    }

    return alquileres;
  } catch (e) {
    print('Error al obtener los alquileres: $e');
    throw Exception('Error al obtener los alquileres: $e');
  }
}

}
