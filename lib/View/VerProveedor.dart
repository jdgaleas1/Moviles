import 'package:flutter/material.dart';

class VerProveedor extends StatefulWidget {
  const VerProveedor({super.key});

  @override
  State<VerProveedor> createState() => _VerProveedorState();
}

class _VerProveedorState extends State<VerProveedor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Proveedores'),
      ),
      body: ListView.builder(
        itemCount: 5, // Número de proveedores en la lista
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/provider_placeholder.png'), // Imagen de ejemplo
              ),
              title: Text('Proveedor $index'), // Información de ejemplo
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Descripción del proveedor $index'),
                  Text('Contacto: contacto$index@empresa.com'),
                  Text('Teléfono: +123456789'),
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
          // Acción de agregar nuevo proveedor
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: VerProveedor(),
  ));
}
