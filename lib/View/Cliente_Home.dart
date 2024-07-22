import 'package:flutter/material.dart';

class ClienteHome extends StatefulWidget {
  const ClienteHome({super.key});

  @override
  State<ClienteHome> createState() => _ClienteHomeState();
}

class _ClienteHomeState extends State<ClienteHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quito'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recomendado'),
            Tab(text: 'Cercanos'),
            Tab(text: 'Buscar'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          RecomendadoTab(),
          CercanosTab(),
          BuscarTab(),
        ],
      ),
    );
  }
}

class RecomendadoTab extends StatelessWidget {
  const RecomendadoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Reemplaza esto con el número de elementos en tu lista
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: Image.asset('assets/images/car.png'), // Reemplaza con la imagen correcta
            title: Text('Nombre del carro $index'),
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('En terminal . UIO'),
                Text('Política de combust.'),
              ],
            ),
            trailing: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('\$45'), // Reemplaza con el precio correcto
                Text('De 4 sitios'),
              ],
            ),
          ),
        );
      },
    );
  }
}

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