import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:autos/Servicios/Auto_Service.dart';

class AgregarAuto extends StatefulWidget {
  const AgregarAuto({super.key});

  @override
  _AgregarAutoState createState() => _AgregarAutoState();
}

class _AgregarAutoState extends State<AgregarAuto> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController marcacontroller = TextEditingController(text: "");
  TextEditingController empresacontroller = TextEditingController(text: "");
  TextEditingController descripcioncontroller = TextEditingController(text: "");
  TextEditingController caracteristicacontroller = TextEditingController(text: "");
  TextEditingController preciocontroller = TextEditingController(text: "");
  File? _imageFile;

  _selectImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  _guardarAuto() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        // Llama a la función guardarAuto aquí
        await guardarAuto(
          marcacontroller.text,
          empresacontroller.text,
          descripcioncontroller.text,
          caracteristicacontroller.text,
          preciocontroller.text,
          _imageFile!.path, // Asegúrate de pasar la ruta de la imagen
        ).then((_) {
          Navigator.pop(context);
        });
      } else {
        // Muestra un mensaje de error si la imagen no está seleccionada
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor seleccione una imagen')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Auto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _imageFile == null
                  ? const Text('No se ha seleccionado una imagen.')
                  : Image.file(_imageFile!, height: 200),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _selectImage(ImageSource.gallery),
                    child: const Text('Subir Imagen'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectImage(ImageSource.camera),
                    child: const Text('Tomar Foto'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: marcacontroller,
                decoration: const InputDecoration(labelText: 'Marca del Auto'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la marca del auto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: empresacontroller,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la Placa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descripcioncontroller,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la descripción';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: caracteristicacontroller,
                decoration: const InputDecoration(labelText: 'Características'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese las características';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: preciocontroller,
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _guardarAuto,
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
