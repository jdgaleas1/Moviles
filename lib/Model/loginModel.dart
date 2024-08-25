class LoginModel {
  final String nombre;
  final String apellido;
  final int telefono;
  final String user;
  final String password;
  final bool esCliente;
  final bool esProveedor;

  LoginModel({
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.user,
    required this.password,
    required this.esCliente,
    required this.esProveedor,
  });

  factory LoginModel.fromFirestore(Map<String, dynamic> data) {
    return LoginModel(
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      telefono: data['telefono'] ?? 0,
      user: data['user'] ?? '',
      password: data['contra'] ?? '',
      esCliente: data['esCliente'] ?? false,
      esProveedor: data['esProveedor'] ?? false,
    );
  }
}
