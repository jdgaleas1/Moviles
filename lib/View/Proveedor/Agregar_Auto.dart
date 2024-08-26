import 'dart:convert';
import 'dart:typed_data';
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
  TextEditingController caracteristicacontroller =
      TextEditingController(text: "");
  TextEditingController preciocontroller = TextEditingController(text: "");
  TextEditingController ciudadcontroller = TextEditingController(text: ""); 
  TextEditingController provinciacontroller = TextEditingController(text: ""); 
  Uint8List? _imageBytes;  // Almacenar los bytes de la imagen

  // Función para seleccionar la imagen
  _selectImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      // Leer los bytes de la imagen
      _imageBytes = await image.readAsBytes();
      setState(() {}); // Actualizar el estado después de que la imagen se haya leído
    }
  }

  // Función para guardar el auto con la imagen
  _guardarAuto() async {
    if (_formKey.currentState!.validate()) {
      if (_imageBytes != null) {
        try {
          // Convertir los bytes de la imagen a una cadena base64
          String base64Image = base64Encode(_imageBytes!);

          // Llamar al método que guarda el auto con la imagen en base64
          await guardarAuto(
            marcacontroller.text,
            empresacontroller.text,
            descripcioncontroller.text,
            caracteristicacontroller.text,
            preciocontroller.text,
            base64Image, // Pasar la imagen en base64
            ciudadcontroller.text,
            provinciacontroller.text,
          );
          Navigator.pop(context, true); // Devuelve true si se agregó el auto con éxito.
        } catch (e) {
          // Muestra un mensaje de error si ocurre un problema
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        // Muestra un mensaje de error si la imagen no está seleccionada
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor seleccione una imagen')),
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
              _imageBytes == null
                  ? const Text('No se ha seleccionado una imagen.')
                  : Image.memory(_imageBytes!, height: 200),  // Mostrar la imagen a partir de bytes
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
              const SizedBox(height: 10),
              TextFormField(
                controller: provinciacontroller,
                decoration: const InputDecoration(labelText: 'Provincia'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la provincia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: ciudadcontroller,
                decoration: const InputDecoration(labelText: 'Ciudad'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la ciudad';
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
                      Navigator.pop(context, true); 
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
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
