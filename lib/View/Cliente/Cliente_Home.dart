// cliente_home.dart
import 'package:autos/Model/EstadosModel.dart';
import 'package:autos/View/Login/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:autos/View/Cliente/Cliente_reservas.dart';
import 'package:autos/View/Cliente/Tabs/tabBuscar.dart';

import 'package:autos/View/Cliente/Tabs/tabTodos.dart';
import 'package:autos/View/Drawer.dart';

class ClienteHome extends StatefulWidget {
   ClienteHome({super.key});

  @override
  State<ClienteHome> createState() => _ClienteHomeState();
}

class _ClienteHomeState extends State<ClienteHome> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var buttonVisibility = Provider.of<Estados>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:  Size.fromHeight(kToolbarHeight),
        child: AppBar(
          bottom: TabBar(
            controller: _tabController,
            tabs:  [
              Tab(text: 'Todos'),
              Tab(text: 'Buscar'),
            ],
            labelStyle:  TextStyle(fontSize: 14),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodosTab(),
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
        esCliente: esCliente,
      ),
      floatingActionButton: Stack(
        children: [
          if (buttonVisibility.carritoVisible)
            Positioned(
              bottom: 80,
              right: 10,
              child: FloatingActionButton(
                heroTag: 'carrito',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  ClienteReservas()),
                  );
                },
                child:  Icon(Icons.shopping_cart),
                tooltip: 'Carrito',
              ),
            ),
          if (buttonVisibility.lupaVisible)
            Positioned(
              bottom: 10,
              right: 10,
              child: FloatingActionButton(
                heroTag: 'lupa',
                onPressed: () {
                  _tabController.animateTo(1);
                },
                child:  Icon(Icons.search),
                tooltip: 'Buscar',
              ),
            ),
        ],
      ),
    );
  }
}
