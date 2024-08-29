  class Auto {
    int id;
    String marca;
    String placa;
    String descripcion;
    String caracteristicas;
    double precio;
    String imageBase64;
    String ciudad;
    String provincia;

    Auto({
      required this.id,
      required this.marca,
      required this.placa,
      required this.descripcion,
      required this.caracteristicas,
      required this.precio,
      required this.imageBase64,
      required this.ciudad,
      required this.provincia,
    });

    // Factory constructor para crear una instancia de Auto a partir de un Map
    factory Auto.fromFirestore(Map<String, dynamic> data) {
      return Auto(
        id: (data['id'] as num?)?.toInt() ?? 0, // Asegúrate de que 'id' sea int
        marca: data['marca'] ?? '',
        placa: data['placa'] ?? '',
        descripcion: data['descripcion'] ?? '',
        caracteristicas: data['caracteristicas'] ?? '',
        precio: double.tryParse(data['precio'].toString()) ?? 0.0, 
        imageBase64: data['imagePath'] ?? '',
        ciudad: data['ciudad'] ?? '',
        provincia: data['provincia'] ?? '',
      );
    }
      // Método toMap para convertir la instancia de Auto a un mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'marca': marca,
      'placa': placa,
      'descripcion': descripcion,
      'caracteristicas': caracteristicas,
      'precio': precio,
      'imageBase64': imageBase64,
      'ciudad': ciudad,
      'provincia': provincia,
    };
  }
  }
