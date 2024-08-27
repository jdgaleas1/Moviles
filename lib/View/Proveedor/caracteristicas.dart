import 'package:flutter/material.dart';

class Caracteristica {
  final IconData icon;
  final String nombre;
  final int maxItems;
  final int seleccionados;

  Caracteristica(this.icon, this.nombre, this.maxItems, this.seleccionados);
}

List<Caracteristica> caracteristicas = [
  Caracteristica(Icons.door_sliding, '4 puertas', 24, 6),
  Caracteristica(Icons.ac_unit, 'Aire acondicionado', 24, 6),
  Caracteristica(Icons.electric_car, 'Levantavidrios eléctricos', 24, 6),
  Caracteristica(Icons.lock, 'Cierre centralizado', 24, 6),
  Caracteristica(Icons.directions_car_filled, 'Dirección Asistida', 24, 6),
  Caracteristica(Icons.no_crash, 'Air bag', 24, 6),
  Caracteristica(Icons.work, '1 maleta(s) grande(s)', 24, 6),
  Caracteristica(Icons.work_outline, '2 maleta(s) pequeña(s)', 24, 6),
  Caracteristica(Icons.group, '6 personas', 24, 6),
];
