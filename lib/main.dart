import 'package:autos/View/Cliente/Cliente_Home.dart';
import 'package:autos/View/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:autos/View/Cliente/Cliente_reservas.dart';
import 'package:autos/View/Login/login.dart';
import 'package:autos/View/Proveedor/Proveedor_CRUD.dart';
import 'package:autos/View/Proveedor/Proveedor_VerReservas.dart';

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
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Color.fromARGB(255, 7, 255, 44),
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
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
        const ClienteHome(),
        const ClienteReservas(),
      ];
    } else if (esProveedor) {
      _content = [
        const Proveedor(),
        const VerSolicitudesReserva(),
      ];
    } else {
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
        title: const Text("Alquiler"),
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
        selectedItemColor: const Color.fromARGB(255, 110, 172, 218),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      drawer: CustomDrawer(
        onItemTapped: _onItemTapped,
        onLogout: () => _cerrarSesion(context),
      ),
    );
  }
}
