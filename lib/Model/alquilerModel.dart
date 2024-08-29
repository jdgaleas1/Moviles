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

  // Método fromFirestore
  factory Alquiler.fromFirestore(Map<String, dynamic> map, String documentId) {
    return Alquiler(
      id_alquiler: documentId,
      autoID: map['autoID'] ?? '',
      usuarioID: map['usuarioID'] ?? '',
      disponible: map['disponible'] ?? false,
      estado: map['estado'] ?? false,
    );
  }

  // Método fromMap (manténlo si lo necesitas para otros propósitos)
  factory Alquiler.fromMap(Map<String, dynamic> map, String documentId) {
    return Alquiler(
      id_alquiler: documentId,
      autoID: map['autoID'] ?? '',
      usuarioID: map['usuarioID'] ?? '',
      disponible: map['disponible'] ?? false,
      estado: map['estado'] ?? false,
    );
  }
}
