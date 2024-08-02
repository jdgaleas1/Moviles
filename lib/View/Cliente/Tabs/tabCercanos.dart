
import 'package:flutter/material.dart';

class CercanosTab extends StatelessWidget {
  const CercanosTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Similar a RecomendadoTab, pero con datos diferentes
    return ListView.builder(
      itemCount: 10, // Reemplaza esto con el número de elementos en tu lista
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset('assets/images/car.png'), // Reemplaza con la imagen correcta
            title: Text('Carro cercano $index'),
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ubicación cercana'),
                Text('Otra información'),
              ],
            ),
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$42'), // Reemplaza con el precio correcto
                Text('De 4 sitios'),
              ],
            ),
          ),
        );
      },
    );
  }
}