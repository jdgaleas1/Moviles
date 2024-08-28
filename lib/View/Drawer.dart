import 'package:autos/Model/EstadosModel.dart';
import 'package:autos/Model/TemasModel.dart';
import 'package:autos/View/Login/RecuperarContra.dart';
import 'package:autos/View/SobreNosotros.dart';
import 'package:autos/View/editarPerfil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  final VoidCallback onLogout;
  final bool esCliente;

  CustomDrawer({
    super.key,
    required this.onItemTapped,
    required this.onLogout,
    required this.esCliente,
  });

  @override
  Widget build(BuildContext context) {
        final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;


    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
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
          Column(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
                radius: 40,
              ),
                const SizedBox(height: 10),          
              Text(
                '${user?.nombre ?? "Nombre"}${user?.apellido ?? "Apellido"}',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              onItemTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.car_rental_outlined),
            title: const Text('Reservas Hechas'),
            onTap: () {
              onItemTapped(1);
              Navigator.pop(context);
            },
                  ),
        ExpansionTile(
          leading: Icon(Icons.badge),
          title: Text('Perfil Datos'),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Usuario: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '${user?.user ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Nombres: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '${user?.nombre ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
                        Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Apellidos: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '${user?.apellido ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Telefono: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '0${user?.telefono ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Correo: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    '${user?.email ?? ""}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Text(
                    'Tipo de usuario: ',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold, // Negrita
                          fontSize: 12,
                        ),
                  ),
                  Text(
                    esCliente ? 'Cliente' : 'Proveedor',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.edit_note),
              title: Text('Editar Perfil'),
              onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfilePage(user: user!)),
                    );

              },
            ),
            ListTile(
              leading: Icon(Icons.password),
              title: Text('Cambiar contraseña'),
              onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RecuperarContra()),
                    );

              },
            ),
          ],
        ),


          ExpansionTile(
            leading: Icon(Icons.settings),
            title: Text('Configuración'),
            children: <Widget>[
              if (esCliente) ...[
                SwitchListTile(
                  title: Text('Mostrar Lupa'),
                  value: Provider.of<Estados>(context).lupaVisible,
                  onChanged: (bool value) {
                    Provider.of<Estados>(context, listen: false)
                        .toggleLupaVisibility();
                  },
                ),
                SwitchListTile(
                  title: Text('Mostrar Carrito'),
                  value: Provider.of<Estados>(context).carritoVisible,
                  onChanged: (bool value) {
                    Provider.of<Estados>(context, listen: false)
                        .toggleCarritoVisibility();
                  },
                ),
              ],
              SwitchListTile(
                title: Text('Tema Claro'),
                value: Provider.of<ThemeProvider>(context).getTheme() ==
                    AppThemes.lightTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setTheme(AppThemes.lightTheme);
                },
              ),
              SwitchListTile(
                title: Text('Tema Oscuro'),
                value: Provider.of<ThemeProvider>(context).getTheme() ==
                    AppThemes.darkTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setTheme(AppThemes.darkTheme);
                },
              ),
              SwitchListTile(
                title: Text('Tema Azul'),
                value: Provider.of<ThemeProvider>(context).getTheme() ==
                    AppThemes.blueTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setTheme(AppThemes.blueTheme);
                },
              ),
              SwitchListTile(
                title: Text('Tema Rosa'),
                value: Provider.of<ThemeProvider>(context).getTheme() ==
                    AppThemes.pinkTheme,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .setTheme(AppThemes.pinkTheme);
                },
              ),
            ],
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Información'),
            onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InformativePage()),
                    );
            },
          ),




          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onLogout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 242, 117, 8),
                padding:
                    EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
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
