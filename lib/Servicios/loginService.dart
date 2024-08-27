import 'package:autos/Model/loginModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autos/Model/EstadosModel.dart';

class LoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LoginModel?> login(BuildContext context, String email, String password) async {
    try {
      // Realiza una consulta a la colección 'usuarios' para encontrar un documento con el usuario proporcionado
      QuerySnapshot querySnapshot = await _firestore
          .collection('usuarios')
          .where('user', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        
        // Hay al menos un documento con el usuario proporcionado
        DocumentSnapshot doc = querySnapshot.docs.first;
        
        // Obtén el ID del documento
        String documentId = doc.id;
        
        
        // Actualiza el modelo con el ID del documento
        LoginModel user = LoginModel.fromFirestore(doc.data() as Map<String, dynamic>, documentId);
    print('Datos del documento: ${doc.data()}');
print('ID del documento: $documentId');
        // Aquí deberías usar un método seguro para comparar contraseñas
        if (_verifyPassword(password, user.password)) {
          // Actualiza el UserProvider con los datos del usuario
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          
          return user; // Credenciales correctas
        } else {
          return null; // Contraseña incorrecta
        }
      } else {
        return null; // Usuario no encontrado
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null; // Error durante el login
    }
  }

  bool _verifyPassword(String inputPassword, String storedPassword) {
    // Implementar la verificación segura de contraseñas
    return inputPassword == storedPassword; // Esto debe ser reemplazado por comparación de hash
  }
}
