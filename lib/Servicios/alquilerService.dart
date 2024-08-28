import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:autos/Servicios/loginService.dart';
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

class DetalleAlquilerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LoginService _loginService = LoginService();


  Future<DetalleAlquiler?> obtenerDetalleAlquiler(String autoID, String usuarioID) async {
    try {
      // Obtener los datos del auto usando AutoService
      Auto? auto = await getAutoById(int.parse(autoID));
      if (auto == null) {
        throw Exception('Auto no encontrado');
      }

      // Obtener los datos del usuario usando LoginService
      LoginModel? usuario = await _loginService.getUserById(usuarioID);
      if (usuario == null) {
        throw Exception('Usuario no encontrado');
      }

      // Crear el objeto DetalleAlquiler con la información obtenida
      DetalleAlquiler detalle = DetalleAlquiler(
        autoID: autoID,
        marcaAuto: auto.marca,
        placaAuto: auto.placa,
        usuarioID: usuarioID,
        nombreUsuario: usuario.nombre,
        apellidoUsuario: usuario.apellido,
        telefonoUsuario: usuario.telefono.toString(),
      );

      return detalle;
    } catch (e) {
      print('Error al obtener los detalles del alquiler: $e');
      return null;
    }
  }
}