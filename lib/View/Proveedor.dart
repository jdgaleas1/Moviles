import 'package:flutter/material.dart';

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
        title: const Text('Proveedores de Autos'),
      ),
      body: ListView.builder(
        itemCount: 5,  // Número de autos en la lista
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: Image.asset('assets/images/car_login.jpg', width: 100, height: 150, fit: BoxFit.cover), 
              title: Text('Marca del Auto $index (Año)'), 
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Empresa'),
                  Text('Descripción del auto $index'),
                  Text('Características de la empresa $index'),
                  Text('Precio: \$XX'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Acción de editar
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Acción de agregar nuevo auto
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: Proveedor(),
  ));
}
