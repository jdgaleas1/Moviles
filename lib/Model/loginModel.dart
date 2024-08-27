import 'package:flutter/material.dart';

class LoginModel {
  final String id_usuario;
  final String nombre;
  final String apellido;
  final String  email;
  final int telefono;
  final String user;
  final String password;
  final bool esCliente;
  final bool esProveedor;

  LoginModel({
    required this.id_usuario,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.user,
    required this.password,
    required this.esCliente,
    required this.esProveedor,
  });

  factory LoginModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return LoginModel(
      id_usuario: documentId, // Usa el ID del documento
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      email: data['email'] ?? '',
      telefono: data['telefono'] ?? 0,
      user: data['user'] ?? '',
      password: data['contra'] ?? '',
      esCliente: data['esCliente'] ?? false,
      esProveedor: data['esProveedor'] ?? false,
    );
  }
  
}
