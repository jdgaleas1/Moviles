import 'package:autos/Model/EstadosModel.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autos/Model/EstadosModel.dart';

class LoginService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<LoginModel?> login(BuildContext context, String email, String password) async {
  Future<LoginModel?> login(
      BuildContext context, String email, String password) async {
    try {
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
        LoginModel user = LoginModel.fromFirestore(
            doc.data() as Map<String, dynamic>, documentId);
        print('Datos del documento: ${doc.data()}');
        print('ID del documento: $documentId');
        // Aquí deberías usar un método seguro para comparar contraseñas
        if (_verifyPassword(password, user.password)) {
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          
          return user;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  bool _verifyPassword(String inputPassword, String storedPassword) {
    return inputPassword == storedPassword; // Implementar verificación de hash seguro
    return inputPassword ==
        storedPassword; // Implementar verificación de hash seguro
  }

  Future<LoginModel?> getUserById(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('usuarios').doc(userId).get();
      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(userId).get();

      if (doc.exists) {
        return LoginModel.fromFirestore(doc.data() as Map<String, dynamic>, userId);
        return LoginModel.fromFirestore(
            doc.data() as Map<String, dynamic>, userId);
      } else {
        print('Usuario no encontrado con ID: $userId');
        return null;
      }
    } catch (e) {
      print('Error al obtener el usuario por ID: $e');
      return null;
    }
  }
}
