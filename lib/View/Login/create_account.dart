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
  final TextEditingController _usernameController = TextEditingController();
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

        // Convertir el número de teléfono a un entero, si es posible
        int phoneNumber;
        try {
          phoneNumber = int.parse(_phoneController.text.replaceAll(
              RegExp(r'\D'), '')); // Elimina caracteres no numéricos
        } catch (e) {
          phoneNumber = 0; // Manejo de errores si la conversión falla
          print('Error al convertir el teléfono a número: $e');
        }

        // Guardar datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'apellido': _lastNameController.text,
          'contra': _passwordController.text,
          'esCliente': _isClient,
          'esProveedor': _isProvider,
          'nombre': _firstNameController.text,
          'telefono': phoneNumber,
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
              //Navigator.of(context).pop();
              Navigator.pop(context);
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            'assets/images/car_login.jpg',
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  obscureText: true,
                ),
                TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                TextField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Apellido',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Teléfono',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _createUser,
                  child: Text('Crear Cuenta'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
