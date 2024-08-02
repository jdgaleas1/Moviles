import 'package:flutter/material.dart';

class BuscarTab extends StatelessWidget {
  const BuscarTab({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Buscar',
              prefixIcon: const Icon(Icons.search, color: Colors.black),
              suffixIcon: const Icon(Icons.filter_list, color: Colors.black), // Icono de filtro
              filled: true,
              fillColor: Colors.white.withOpacity(0.8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}