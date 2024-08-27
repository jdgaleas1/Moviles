import 'package:autos/Model/TemasModel.dart';
import 'package:autos/Model/EstadosModel.dart';
import 'package:autos/View/Cliente/Cliente_Home.dart';
import 'package:autos/View/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:autos/View/Cliente/Cliente_reservas.dart';
import 'package:autos/View/Login/login.dart';
import 'package:autos/View/Proveedor/Proveedor_CRUD.dart';
import 'package:autos/View/Proveedor/Proveedor_VerReservas.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:autos/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Estados()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(AppThemes.lightTheme),
        ),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child:  MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtén el tema actual del ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Alquiler',
      theme: themeProvider.getTheme(),
      home:  LoginPage(), // Asegúrate de tener esta página definida
      debugShowCheckedModeBanner: false,
    );
  }
}
class MyHomePage extends StatefulWidget {
   MyHomePage({super.key, required this.title});
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
         Proveedor(),
         VerSolicitudesReserva(),
      ];
    } else {
      _content = [
        Center(
            child: Text(
                'cliente: ${esCliente.toString()} proveedor: ${esProveedor.toString()}')),
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
      MaterialPageRoute(builder: (context) =>  LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:  Text("Alquiler"),
      ),
      body: Center(
        child: _content[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
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
        selectedItemColor:  Color.fromARGB(255, 110, 172, 218),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      drawer: CustomDrawer(
        onItemTapped: _onItemTapped,
        onLogout: () => _cerrarSesion(context),
        esCliente: esCliente,
      ),
    );
  }
}
