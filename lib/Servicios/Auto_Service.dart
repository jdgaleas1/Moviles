import 'package:autos/Model/AutoModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<List> getAuto() async {
  /*List<Auto> _autos = [
    Auto(id: 0, marca: 'Beat', placa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 10000, imagePath: 'assets/images/buggati.jpg', ciudad: 'Quito', provincia: 'Pichincha'),
    Auto(id: 1, marca: 'Kwid', placa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 11800, imagePath: 'assets/images/buggati.jpg', ciudad: 'Guayaquil', provincia: 'Guayas'),
    Auto(id: 2, marca: 'Beat', placa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 7000, imagePath: 'assets/images/buggati.jpg', ciudad: 'Cuenca', provincia: 'Azuay'),
    Auto(id: 3, marca: 'Kwid', placa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 15000, imagePath: 'assets/images/buggati.jpg', ciudad: 'Ambato', provincia: 'Tungurahua'),
    Auto(id: 4, marca: 'Beat', placa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 15000, imagePath: 'assets/images/buggati.jpg', ciudad: 'Quito', provincia: 'Pichincha'),
    Auto(id: 5, marca: 'Kwid', placa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 11050, imagePath: 'assets/images/buggati.jpg', ciudad: 'Guayaquil', provincia: 'Guayas'),
  ];
  return _autos;*/
  List<Auto> _autos = [];

  try {
    // Obtiene la colección de autos desde Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('auto').get();

    // Mapea los documentos a instancias de Auto
    _autos = snapshot.docs.map((doc) {
      return Auto.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();

  } catch (e) {
    print('Error al obtener los autos: $e');
  }

  return _autos;

}

Future<int> getNextAutoId() async {
  int nextId = 0;

  try {
    // Consulta para obtener el auto con el mayor id
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('auto')
        .orderBy('id', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      int lastId = snapshot.docs.first['id'];  // Captura el último id
      print('Último id consultado: $lastId');
      nextId = lastId + 1;  // Incrementa el id
      
    } else {
      nextId = 1;  // Si no hay autos en la colección, comienza en 1
      print('No se encontraron autos, comenzando en ID 1');
    }
    
    print('Nuevo id: $nextId');
  } catch (e) {
    print('Error al obtener el próximo ID: $e');
  }

  return nextId;
}


Future<void> guardarAuto(String marca, String placa, String descripcion, String caracteristicas, String precio, String imagePath, String ciudad, String provincia) async {
  int nuevoId = await getNextAutoId();
  print("llegó al guardar");
  try {
    print("llegó al try");
    // Crear un nuevo documento con el id autoincremental
    await FirebaseFirestore.instance.collection('auto').doc(nuevoId.toString()).set({
      'id': nuevoId,
      'marca': marca,
      'placa': placa,
      'descripcion': descripcion,
      'caracteristicas': caracteristicas,
      'precio': double.parse(precio),
      'imagePath': imagePath,
      'ciudad': ciudad,
      'provincia': provincia,
    });

    print("Auto guardado exitosamente con ID $nuevoId en $ciudad, $provincia");
  } catch (e) {
    print('Error al guardar el auto: $e');
  }
}

Future<void> editarAuto(int id, String marca, String placa, String descripcion, String caracteristicas, String precio, String? imagePath, String ciudad, String provincia) async {
  print("llegó al guardar");
  try {
    print("llegó al try");
    // Actualiza el documento en la colección 'auto' con el ID especificado
    await FirebaseFirestore.instance.collection('auto').doc(id.toString()).update({
      'marca': marca,
      'placa': placa,
      'descripcion': descripcion,
      'caracteristicas': caracteristicas,
      'precio': double.parse(precio), // Asegúrate de que el precio esté en formato double
      'imagePath': imagePath ?? '', // Si no se proporciona imagePath, usa una cadena vacía
      'ciudad': ciudad,
      'provincia': provincia,
    });

    print("Auto actualizado exitosamente con ID: $id");
    print("Ciudad: $ciudad, Provincia: $provincia");
  } catch (e) {
    print('Error al actualizar el auto: $e');
  }
}

Future<void> eliminarAuto(int id) async {
  try {
    // Elimina el documento en la colección 'auto' con el ID especificado
    await FirebaseFirestore.instance.collection('auto').doc(id.toString()).delete();

    print("Auto eliminado exitosamente con ID: $id");
  } catch (e) {
    print('Error al eliminar el auto: $e');
  }
}
