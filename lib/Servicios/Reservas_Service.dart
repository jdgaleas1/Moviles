import 'package:autos/Model/Reserva.dart';
import 'package:autos/Model/AlquilerModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Reserva>> getReservas() async {
  List<Reserva> reservas = [];

  try {
    // Obtiene la colección de reservas desde Firestore
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('reserva').get();

    // Mapea los documentos a instancias de Reserva
    reservas = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error al obtener las reservas: $e');
  }

  return reservas;
}

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

Future<int> getNextReservaId() async {
  int nextId = 0;

  try {
    // Consulta para obtener la reserva con el mayor id
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('reserva')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int lastId = snapshot.docs.first['id']; // Captura el último id
      print('Último id consultado: $lastId');
      nextId = lastId + 1; // Incrementa el id
    } else {
      nextId = 1; // Si no hay reservas en la colección, comienza en 1
      print('No se encontraron reservas, comenzando en ID 1');
    }

    print('Nuevo id: $nextId');
  } catch (e) {
    print('Error al obtener el próximo ID: $e');
  }

  return nextId;
}

Future<void> guardarReserva(
    DateTime fechaIni, DateTime fechaFin, String idAlquiler) async {
  int nuevoId = await getNextReservaId();
  print("llegó al guardar");
  try {
    print("llegó al try");
    // Crear un nuevo documento con el id autoincremental
    await FirebaseFirestore.instance
        .collection('reserva')
        .doc(nuevoId.toString())
        .set({
      'id': nuevoId,
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'id_alquiler': idAlquiler,
    });

    print(
        "Reserva guardada exitosamente con ID $nuevoId, Alquiler ID: $idAlquiler");
  } catch (e) {
    print('Error al guardar la reserva: $e');
  }
}

Future<void> editarReserva(
    int id, DateTime fechaIni, DateTime fechaFin, String idAlquiler) async {
  print("llegó al guardar");
  try {
    print("llegó al try");
    // Actualiza el documento en la colección 'reserva' con el ID especificado
    await FirebaseFirestore.instance
        .collection('reserva')
        .doc(id.toString())
        .update({
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'id_alquiler': idAlquiler,
    });

    print(
        "Reserva actualizada exitosamente con ID: $id, Alquiler ID: $idAlquiler");
  } catch (e) {
    print('Error al actualizar la reserva: $e');
  }
}

Future<void> eliminarReserva(int id) async {
  try {
    // Elimina el documento en la colección 'reserva' con el ID especificado
    await FirebaseFirestore.instance
        .collection('reserva')
        .doc(id.toString())
        .delete();

    print("Reserva eliminada exitosamente con ID: $id");
  } catch (e) {
    print('Error al eliminar la reserva: $e');
  }
}

final CollectionReference _alquilerCollection =
    FirebaseFirestore.instance.collection('alquiler');
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
