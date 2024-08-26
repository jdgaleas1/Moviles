import 'dart:convert';
import 'dart:typed_data';
import 'package:autos/Model/AutoModel.dart';
import 'package:autos/Servicios/Auto_Service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditarAuto extends StatefulWidget {
  final Auto auto;

  const EditarAuto({required this.auto});

  @override
  _EditarAutoState createState() => _EditarAutoState();
}

class _EditarAutoState extends State<EditarAuto> {
  final _formKey = GlobalKey<FormState>();
  Uint8List? _imageBytes;

  TextEditingController marcaController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController caracteristicaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();
  TextEditingController provinciaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    marcaController.text = widget.auto.marca;
    placaController.text = widget.auto.placa;
    descripcionController.text = widget.auto.descripcion;
    caracteristicaController.text = widget.auto.caracteristicas;
    precioController.text = widget.auto.precio.toString();
    ciudadController.text = widget.auto.ciudad;
    provinciaController.text = widget.auto.provincia;

    // Decodificar la imagen base64 almacenada y convertirla a Uint8List
    if (widget.auto.imageBase64.isNotEmpty) {
      _imageBytes = base64Decode(widget.auto.imageBase64);
    }
  }

  _selectImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      _imageBytes = await image.readAsBytes(); // Lee los bytes de la imagen seleccionada
      setState(() {});
    }
  }

  _guardarAuto() async {
    if (_formKey.currentState!.validate()) {
      try {
        double? precio = double.tryParse(precioController.text);
        if (precio == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Por favor ingrese un precio válido')),
          );
          return;
        }

        String? base64Image = _imageBytes != null ? base64Encode(_imageBytes!) : null;

        await editarAuto(
          widget.auto.id,
          marcaController.text,
          placaController.text,
          descripcionController.text,
          caracteristicaController.text,
          precio.toString(),
          base64Image,
          ciudadController.text,
          provinciaController.text,
        ).then((_) {
          Navigator.pop(context, true);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Auto ${widget.auto.marca}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _imageBytes != null
                  ? Image.memory(_imageBytes!, height: 200, fit: BoxFit.cover)
                  : const Text('No hay imagen disponible'),
              const SizedBox(height: 20),
              TextFormField(
                controller: marcaController,
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
                controller: placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la placa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descripcionController,
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
                controller: caracteristicaController,
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
                controller: precioController,
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
                controller: provinciaController,
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
                controller: ciudadController,
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
