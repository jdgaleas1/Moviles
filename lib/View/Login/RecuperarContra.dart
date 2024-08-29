import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarContra extends StatefulWidget {
  @override
  _RecuperarContraState createState() => _RecuperarContraState();
}

class _RecuperarContraState extends State<RecuperarContra> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _resetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Se ha enviado un correo para restablecer la contraseña.'),
      ));
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al enviar el correo de recuperación.'),
      ));
    }
  }

  void _updateFirestorePassword(String email, String newPassword) async {
    try {
      final userDoc = await _firestore
          .collection('usuarios')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        await _firestore
            .collection('usuarios')
            .doc(userDoc.docs.first.id)
            .update({'contra': newPassword});
        print('Contraseña actualizada en Firestore.');
      } else {
        print('No se encontró el usuario.');
      }
    } catch (e) {
      print('Error al actualizar la contraseña en Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/car_login.jpg',
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    filled:
                        true, // Esto hace que el fondo del TextField sea opaco
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Nueva Contraseña',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _resetPassword();
                    _updateFirestorePassword(
                        _emailController.text, _passwordController.text);
                  },
                  child: Text('Recuperar Contraseña'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}