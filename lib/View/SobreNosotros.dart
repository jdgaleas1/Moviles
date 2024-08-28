import 'package:flutter/material.dart';

class InformativePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Información",
          style: TextStyle(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onPrimary, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: theme.colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Image.asset(
                "assets/images/espe-carrera-de-software.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image.asset(
                'assets/images/edificio.png',
                width: 325,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '¿Sobre nosotros?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Grupo 5 del curso Desarrollo Movil NRC:16829. \nIntegrantes:\n  -Joel Cuenca.\n  -Carlos Chasi.\n  -Johan Galeas.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onBackground,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¿Desea ser alquilador/proveedor?',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Para acceder al sistema como alquilador contactenos.',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onBackground,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    '¡Contáctanos!',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                  Text(
                    'Puede comunicarse con nosotros a través de correo:\n   -jdgaleas1@esp.edu.ec\n   -ajcuenca4@espe.edu.ec\n   -chasicarlos1a@gmail.com',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onBackground,
                      height: 1.5,
                    ),
                  ),
                              SizedBox(height: 10),
            Container(
              width: double.infinity,
              child: Image.asset(
                "assets/images/espe-carrera-de-software.png",
                fit: BoxFit.cover,
              ),
            ),
             SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: theme.colorScheme.background,
    );
  }
}
