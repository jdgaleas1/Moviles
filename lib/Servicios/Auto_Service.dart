import 'package:autos/Model/AutoModel.dart';


Future <List> getAuto() async{
  List<Auto> _autos = [
    Auto(id: 0, marca: 'Beat', empresa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 10000, imagePath: 'assets/images/buggati.jpg'),
    Auto(id: 1, marca: 'Kwid', empresa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 11800, imagePath: 'assets/images/buggati.jpg'),
    Auto(id: 2, marca: 'Beat', empresa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 7000, imagePath: 'assets/images/buggati.jpg'),
    Auto(id: 3, marca: 'Kwid', empresa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 15000, imagePath: 'assets/images/buggati.jpg'),
    Auto(id: 4, marca: 'Beat', empresa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 15000, imagePath: 'assets/images/buggati.jpg'),
    Auto(id: 5, marca: 'Kwid', empresa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 11050, imagePath: 'assets/images/buggati.jpg'),
    
  ];
  return _autos;
}

Future<void> guardarAuto(String marca, String empresa, String descripcion, String caracteristicas, String precio, String image) async {
  
  print("Guardado exitosamente");
}

Future<void> editarAuto(int id, String marca, String empresa, String descripcion, String caracteristicas, String precio, String? imagePath) async {
  
  print("Auto actualizado exitosamente");
  print("ID: $id");
}


Future<void> eliminarAuto(int id) async {
  
  print("Eliminado exitosamente");
}
