import 'dart:io';

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
  File? _imageFile;

  TextEditingController marcaController = TextEditingController();
  TextEditingController placaController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController caracteristicaController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController ciudadController = TextEditingController(); // Nuevo controlador para ciudad
  TextEditingController provinciaController = TextEditingController(); // Nuevo controlador para provincia

  @override
  void initState() {
    super.initState();
    marcaController.text = widget.auto.marca;
    placaController.text = widget.auto.placa;
    descripcionController.text = widget.auto.descripcion;
    caracteristicaController.text = widget.auto.caracteristicas;
    precioController.text = widget.auto.precio.toString();
    ciudadController.text = widget.auto.ciudad; // Inicializa el campo de ciudad
    provinciaController.text = widget.auto.provincia; // Inicializa el campo de provincia
  }

  _selectImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
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
              // Verificación de la imagen seleccionada
              _imageFile != null 
                ? Image.file(
                    _imageFile!,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/buggati.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  )
                : Image.asset(
                    widget.auto.imagePath,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/buggati.jpg',
                        height: 200,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
              const SizedBox(height: 20),
              TextField(
                controller: marcaController,
                decoration: const InputDecoration(labelText: 'Marca del Auto'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: placaController,
                decoration: const InputDecoration(labelText: 'Placa'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: caracteristicaController,
                decoration: const InputDecoration(labelText: 'Características'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: precioController,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: provinciaController, 
                decoration: const InputDecoration(labelText: 'Provincia'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: ciudadController, 
                decoration: const InputDecoration(labelText: 'Ciudad'),
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
                    onPressed: () async {
                      // Guardar cambios del auto
                      await editarAuto(
                        widget.auto.id, 
                        marcaController.text,
                        placaController.text,
                        descripcionController.text,
                        caracteristicaController.text,
                        precioController.text,
                        _imageFile?.path,
                        ciudadController.text, 
                        provinciaController.text, 
                      ).then((_){
                        Navigator.pop(context, true);
                      });
                    },
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, true); // Devuelve true si se editó un auto.
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
