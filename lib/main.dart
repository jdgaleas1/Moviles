import 'package:autos/View/Cliente_Home.dart';
import 'package:flutter/material.dart';
import 'package:autos/View/Alquilador_crud.dart';
import 'package:autos/View/Alquilador_ver.dart';
import 'package:autos/View/Cliente_reservas.dart';
import 'package:autos/View/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alquiler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 242, 117, 8)),
        useMaterial3: true,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color.fromARGB(255, 7, 255, 44),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Widget> _content;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeContent();
  }

  void _initializeContent() {
    if (esCliente) {
      _content = [
        ClienteHome(),
        ClienteReservas(),
      ];
    } else if (esProveedor) {
      _content = [
        AlquiladorVer(),
        alquiladorCrud(),
      ];
    } else {
      // Proporciona una vista predeterminada en caso de error
      _content = [
        Center(child: Text('cliente: ${esCliente.toString()} proveedor: ${esProveedor.toString()}')),
      ];
    }
    _selectedIndex = 0;
  }

  void _onItemTapped(int index) {
    if (index < _content.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _cerrarSesion(BuildContext context) {
    esCliente = false;
    esProveedor = false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Alquiler"),
      ),
      body: Center(
        child: _content[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.car_rental_outlined),
            label: 'Reservas Hechas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 7, 255, 44),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
        child: Column(
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.car_rental_outlined),
              title: Text('Reservas Hechas'),
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _cerrarSesion(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 242, 117, 8),
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
      ),
    );
  }
}
