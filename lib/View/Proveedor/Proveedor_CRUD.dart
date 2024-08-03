import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Proveedor extends StatefulWidget {
  const Proveedor({super.key});

  @override
  State<Proveedor> createState() => _ProveedorState();
}

class _ProveedorState extends State<Proveedor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Autos'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Número de columnas en la cuadrícula
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 1,
        ),
        itemCount: 5,  // Número de autos en la lista
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AutoDetailScreen(index: index),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/buggati.jpg', // Cambia la imagen según el índice
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Marca del Auto $index', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AgregarAuto()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AutoDetailScreen extends StatelessWidget {
  final int index;

  const AutoDetailScreen({required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle del Auto $index'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/buggati.jpg', width: double.infinity, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text('Marca del Auto $index (Año)', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('Empresa'),
            const SizedBox(height: 5),
            Text('Descripción del auto $index'),
            const SizedBox(height: 5),
            Text('Características de la empresa $index'),
            const SizedBox(height: 5),
            const Text('Precio: \$XX'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditarAuto(index: index)),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    // Acción de eliminar
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AgregarAuto extends StatefulWidget {
  const AgregarAuto({super.key});

  @override
  _AgregarAutoState createState() => _AgregarAutoState();
}

class _AgregarAutoState extends State<AgregarAuto> {
  final _formKey = GlobalKey<FormState>();
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
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Año'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el año';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la empresa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Guardar auto
                      }
                    },
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

class EditarAuto extends StatefulWidget {
  final int index;

  const EditarAuto({required this.index});

  @override
  _EditarAutoState createState() => _EditarAutoState();
}

class _EditarAutoState extends State<EditarAuto> {
  final _formKey = GlobalKey<FormState>();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Auto ${widget.index}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Año'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el año';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Empresa'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese la empresa';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
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
                decoration: const InputDecoration(labelText: 'Precio'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el precio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Guardar cambios del auto
                      }
                    },
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

void main() {
  runApp(const MaterialApp(
    home: Proveedor(),
  ));
}
