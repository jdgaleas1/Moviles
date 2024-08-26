import 'package:autos/Model/Reserva.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<List<Reserva>> getReservas() async {
  List<Reserva> reservas = [];

  try {
    // Obtiene la colección de reservas desde Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('reserva').get();

    // Mapea los documentos a instancias de Reserva
    reservas = snapshot.docs.map((doc) {
      return Reserva.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error al obtener las reservas: $e');
  }

  return reservas;
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
    DateTime fechaIni, DateTime fechaFin, int idaut, String idusu) async {
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
      'idaut': idaut,
      'idusu': idusu,
    });

    print("Reserva guardada exitosamente con ID $nuevoId, Auto ID: $idaut, Usuario ID: $idusu");
  } catch (e) {
    print('Error al guardar la reserva: $e');
  }
}

Future<void> editarReserva(int id, DateTime fechaIni, DateTime fechaFin,
    int idaut, String idusu) async {
  print("llegó al guardar");
  try {
    print("llegó al try");
    // Actualiza el documento en la colección 'reserva' con el ID especificado
    await FirebaseFirestore.instance.collection('reserva').doc(id.toString()).update({
      'fecha_ini': fechaIni,
      'fecha_fin': fechaFin,
      'idaut': idaut,
      'idusu': idusu,
    });

    print("Reserva actualizada exitosamente con ID: $id, Auto ID: $idaut, Usuario ID: $idusu");
  } catch (e) {
    print('Error al actualizar la reserva: $e');
  }
}

Future<void> eliminarReserva(int id) async {
  try {
    // Elimina el documento en la colección 'reserva' con el ID especificado
    await FirebaseFirestore.instance.collection('reserva').doc(id.toString()).delete();

    print("Reserva eliminada exitosamente con ID: $id");
  } catch (e) {
    print('Error al eliminar la reserva: $e');
  }
}
