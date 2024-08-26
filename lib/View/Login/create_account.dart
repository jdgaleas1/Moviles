import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // Campo adicional para el nombre de usuario
  bool _isClient = true;
  bool _isProvider = false;

  void _createUser() async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Se ha enviado un correo de verificación. Por favor revisa tu bandeja de entrada.'),
          ));
        }

        // Guardar datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'apellido': _lastNameController.text,
          'contra': _passwordController.text,
          'esCliente': true,
          'esProveedor': false,
          'nombre': _firstNameController.text,
          'telefono': _phoneController.text,
          'user': _usernameController.text, // Guardar nombre de usuario
          'email': user.email ?? '',
        });

        // Esperar a que el usuario verifique su correo
        await _auth.signOut();
        _showEmailVerificationDialog(user);
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al crear la cuenta.'),
      ));
    }
  }

  void _showEmailVerificationDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Verificar correo electrónico'),
        content: Text(
            'Por favor, verifica tu correo electrónico. Luego de verificarlo, por favor inicia sesión.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuenta'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Apellido'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText:
                      'Nombre de Usuario'), // Campo adicional para el nombre de usuario
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createUser,
              child: Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
