import 'package:autos/Model/AutoModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AutoController with ChangeNotifier {
  List<Auto> _autos = [
    Auto(id: 0, marca: 'Beat', empresa: 'Chevrolet', descripcion: 'Descripción del Beat', caracteristicas: 'Características del Beat', precio: 10000, imagePath: 'assets/images/auto_0.jpg'),
    Auto(id: 1, marca: 'Kwid', empresa: 'Renault', descripcion: 'Descripción del Kwid', caracteristicas: 'Características del Kwid', precio: 11000, imagePath: 'assets/images/auto_1.jpg'),
    // Añadir más autos según sea necesario
  ];

  List<Auto> get autos => _autos;

  void addAuto(Auto auto) {
    _autos.add(auto);
    notifyListeners();
  }

  void updateAuto(int id, Auto updatedAuto) {
    int index = _autos.indexWhere((auto) => auto.id == id);
    if (index != -1) {
      _autos[index] = updatedAuto;
      notifyListeners();
    }
  }

  void deleteAuto(int id) {
    _autos.removeWhere((auto) => auto.id == id);
    notifyListeners();
  }

  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }
}
