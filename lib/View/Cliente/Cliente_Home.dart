import 'package:flutter/material.dart';
import 'package:autos/View/Cliente/Cliente_reservas.dart';
import 'package:autos/View/Cliente/Tabs/tabBuscar.dart';
import 'package:autos/View/Cliente/Tabs/tabCercanos.dart';
import 'package:autos/View/Cliente/Tabs/tabTodos.dart';
import 'package:autos/View/Drawer.dart';

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

  void _refresh() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight), // Altura solo para las pestañas
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Todos'),
              Tab(text: 'Cercanos'),
              Tab(text: 'Buscar'),
            ],
            labelStyle: const TextStyle(fontSize: 14), // Tamaño de fuente reducido
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodosTab(),
          CercanosTab(),
          BuscarTab(),
        ],
      ),
      drawer: CustomDrawer(
        onItemTapped: (index) {
          setState(() {
            // Maneja el cambio de contenido basado en el índice seleccionado
          });
        },
        onLogout: () {
          // Implementa la lógica de cerrar sesión aquí
        },
        onToggleVisibility: _refresh, // Llama a _refresh cuando se cambia la visibilidad
      ),
      floatingActionButton: Stack(
        children: [
          if (carritoVisible)
            Positioned(
              bottom: 80,
              right: 10,
              child: FloatingActionButton(
                heroTag: 'carrito',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ClienteReservas()),
                  );
                },
                child: const Icon(Icons.shopping_cart), // Ícono de carrito
                tooltip: 'Carrito',
              ),
            ),
          if (lupaVisible)
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                heroTag: 'lupa',
                onPressed: () {
                  _tabController.animateTo(2);
                },
                child: const Icon(Icons.search), // Ícono de lupa
                tooltip: 'Buscar',
              ),
            ),
        ],
      ),
    );
  }
}
