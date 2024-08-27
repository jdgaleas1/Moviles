class Alquiler {
  final String autoID;
  final String usuarioID;
  final bool disponible;
  final bool estado;

  Alquiler({
    required this.autoID,
    required this.usuarioID,
    required this.disponible,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      'autoID': autoID,
      'usuarioID': usuarioID,
      'disponible': disponible,
      'estado': estado,
    };
  }

  factory Alquiler.fromMap(Map<String, dynamic> map) {
    return Alquiler(
      autoID: map['autoID'],
      usuarioID: map['usuarioID'],
      disponible: map['disponible'],
      estado: map['estado'],
    );
  }
}
