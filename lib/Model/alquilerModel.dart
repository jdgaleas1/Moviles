import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Model/loginModel.dart';

class Alquiler {
  final String id_alquiler;
  final String autoID;
  final String usuarioID;
  final bool disponible;
  final bool estado;
  final Auto? auto;
  final LoginModel? usuario;
   String? imageBase64;

  Alquiler({
    required this.id_alquiler,
    required this.autoID,
    required this.usuarioID,
    required this.disponible,
    required this.estado,
    this.auto,    // Auto asociado
    this.usuario, // Usuario asociado
    this.imageBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id_alquiler,
      'autoID': autoID,
      'usuarioID': usuarioID,
      'disponible': disponible,
      'estado': estado,
      'auto': auto?.toMap(), // Asegúrate de manejar el mapeo aquí si es necesario
      'usuario': usuario?.toMap(), // Lo mismo para el usuario
    };
  }

  factory Alquiler.fromMap(Map<String, dynamic> map, String documentId) {
    return Alquiler(
      id_alquiler: documentId,
      autoID: map['autoID'],
      usuarioID: map['usuarioID'],
      disponible: map['disponible'],
      estado: map['estado'],
      auto: map.containsKey('auto') ? Auto.fromFirestore(map['auto']) : null,
      usuario: map.containsKey('usuario') ? LoginModel.fromFirestore(map['usuario'], '') : null,
    );
  }
}
