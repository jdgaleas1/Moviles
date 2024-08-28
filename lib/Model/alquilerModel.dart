class Alquiler {
  final String id_alquiler;
  final String autoID;
  final String usuarioID;
  final bool disponible;
  final bool estado;

  Alquiler({
    required this.id_alquiler,
    required this.autoID,
    required this.usuarioID,
    required this.disponible,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id_alquiler,
      'autoID': autoID,
      'usuarioID': usuarioID,
      'disponible': disponible,
      'estado': estado,
    };
  }

  factory Alquiler.fromMap(Map<String, dynamic> map,  String documentId) {
    return Alquiler(
      id_alquiler:  documentId, // Usa el ID del documento
      autoID: map['autoID'],
      usuarioID: map['usuarioID'],
      disponible: map['disponible'],
      estado: map['estado'],
    );
  }
}

class DetalleAlquiler {
  final String autoID;
  final String marcaAuto;
  final String placaAuto;
  final String usuarioID;
  final String nombreUsuario;
  final String apellidoUsuario;
  final String telefonoUsuario;


  DetalleAlquiler({
    required this.autoID,
    required this.marcaAuto,
    required this.placaAuto,
    required this.usuarioID,
    required this.nombreUsuario,
    required this.apellidoUsuario,
    required this.telefonoUsuario,
  });
}

