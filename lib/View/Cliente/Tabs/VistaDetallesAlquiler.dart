import 'package:autos/View/Cliente/Tabs/NotifiAgregado.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';

class DetallesAlquilerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    final String Coche = "Mazda de 4 puertas - nombre: -----------";
    final String message = 'Mira este enlace de alquiler de coches!';

    return Scaffold(
      appBar: AppBar(
        elevation: 0, // Elimina la sombra del AppBar para un look más limpio
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),  // Icono de compartir
            onPressed: () {
              FlutterShareMe().shareToWhatsApp(msg: '$message $Coche');
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/car.png',  // Sustituye con la ruta de tu imagen o vídeo
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 10),
                    Text('datos---------------')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow[800]),
                    SizedBox(width: 10),
                    Text('Oferta exclusiva')
                  ],
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Color de fondo del botón
                      foregroundColor: Colors.white, // Color del texto e ícono
                    ),
                    onPressed: () => NotificationHelper.showAddedNotification(context),
                    child: Text('Alquilar Ahora'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
