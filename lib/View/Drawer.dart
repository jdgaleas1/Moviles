import 'package:flutter/material.dart';

// Variables globales para controlar la visibilidad
bool lupaVisible = false;
bool carritoVisible = false;

class CustomDrawer extends StatefulWidget {
  final Function(int) onItemTapped;
  final VoidCallback onLogout;
  final VoidCallback? onToggleVisibility;

  const CustomDrawer({
    super.key,
    required this.onItemTapped,
    required this.onLogout,
     this.onToggleVisibility,
  });

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/car_drawer.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Container(),
          ),
          const SizedBox(height: 16),
          const Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 40,
              ),
              SizedBox(height: 10),
              Text(
                'Usuario123',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'usuario123@espe.edu',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tipo de usuario: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '------------',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              widget.onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.car_rental_outlined),
            title: const Text('Reservas Hechas'),
            onTap: () {
              widget.onItemTapped(1);
              Navigator.pop(context);
            },
          ),
          // Botón de acordeón para los interruptores
          ExpansionTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            children: <Widget>[
              SwitchListTile(
                title: const Text('Mostrar Lupa'),
                value: lupaVisible,
                onChanged: (bool value) {
                  setState(() {
                    lupaVisible = value;
                  });
                  if (widget.onToggleVisibility != null) {
                    widget.onToggleVisibility!();
                  }
                },
              ),
              SwitchListTile(
                title: const Text('Mostrar Carrito'),
                value: carritoVisible,
                onChanged: (bool value) {
                  setState(() {
                    carritoVisible = value;
                  });
                  if (widget.onToggleVisibility != null) {
                    widget.onToggleVisibility!();
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: widget.onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 242, 117, 8),
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Cerrar Sesión',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
