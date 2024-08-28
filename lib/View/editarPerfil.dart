import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autos/Model/loginModel.dart';
import 'package:autos/Model/EstadosModel.dart';

class EditProfilePage extends StatefulWidget {
  final LoginModel user;

  const EditProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  late String _nombre;
  late String _apellido;
  late String _email;
  late String _telefono;
  late String _user;

  @override
  void initState() {
    super.initState();
    // Inicializa los campos del formulario con los valores actuales del usuario
    _nombre = widget.user.nombre;
    _apellido = widget.user.apellido;
    _email = widget.user.email;
    _telefono = widget.user.telefono.toString();
    _user = widget.user.user;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Actualiza los datos del usuario en Firestore
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(widget.user.id_usuario)
            .update({
          'nombre': _nombre,
          'apellido': _apellido,
          'email': _email,
          'telefono': int.parse(_telefono),
          'user': _user,
        });

        // Actualiza el usuario en el UserProvider
        final updatedUser = LoginModel(
          id_usuario: widget.user.id_usuario,
          nombre: _nombre,
          apellido: _apellido,
          email: _email,
          telefono: int.parse(_telefono),
          user: _user,
          password: widget.user.password,
          esCliente: widget.user.esCliente,
          esProveedor: widget.user.esProveedor,
        );

        Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Perfil actualizado con éxito')),
        );

        // Regresa a la pantalla anterior
        Navigator.pop(context);
      } catch (e) {
        print('Error al actualizar el perfil: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar el perfil')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                onSaved: (value) => _nombre = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _apellido,
                decoration: InputDecoration(labelText: 'Apellido'),
                onSaved: (value) => _apellido = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Correo Electrónico'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su correo electrónico';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Por favor ingrese un correo electrónico válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _telefono,
                decoration: InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.phone,
                onSaved: (value) => _telefono = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su teléfono';
                  } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                    return 'Por favor ingrese un número de teléfono válido';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _user,
                decoration: InputDecoration(labelText: 'Usuario'),
                onSaved: (value) => _user = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese su nombre de usuario';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveChanges,
                child: Text('Guardar Cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
