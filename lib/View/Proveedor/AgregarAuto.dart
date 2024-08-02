import 'package:flutter/material.dart';

class AgregarAuto extends StatefulWidget {
  const AgregarAuto({super.key});

  @override
  State<AgregarAuto> createState() => _AgregarAutoState();
}

class _AgregarAutoState extends State<AgregarAuto> {
  final _formKey = GlobalKey<FormState>();

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
                decoration: const InputDecoration(labelText: 'Marca'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Empresa'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Características'),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Aquí puedes agregar la funcionalidad para guardar
                    },
                    child: const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Vuelve a la vista anterior
                    },
                    child: const Text('Cancelar'),
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
