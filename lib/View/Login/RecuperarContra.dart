import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RecuperarContra extends StatefulWidget {
  @override
  _RecuperarContraState createState() => _RecuperarContraState();
}

class _RecuperarContraState extends State<RecuperarContra> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar Contraseña'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Recuperar Contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
