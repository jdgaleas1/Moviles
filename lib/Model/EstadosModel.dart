import 'package:autos/Model/loginModel.dart';
import 'package:flutter/material.dart';

class Estados with ChangeNotifier {
  bool _lupaVisible = false;
  bool _carritoVisible = false;

  bool get lupaVisible => _lupaVisible;
  bool get carritoVisible => _carritoVisible;

  void toggleLupaVisibility() {
    _lupaVisible = !_lupaVisible;
    notifyListeners();
  }

  void toggleCarritoVisibility() {
    _carritoVisible = !_carritoVisible;
    notifyListeners();
  }
  
}

class UserProvider extends ChangeNotifier {
  LoginModel? _user;
  String? _nombre;
  String? _apellido;
  String? _telefono;

  LoginModel? get user => _user;
  String? get nombre => _nombre;
  String? get apellido => _apellido;
  String? get telefono => _telefono;

  void setUser(LoginModel user) {
    _user = user;
    _nombre = user.nombre; // Asumiendo que LoginModel tiene un campo 'nombres'
    _apellido = user.apellido; // Asumiendo que LoginModel tiene un campo 'apellidos'
    _telefono = user.telefono.toString(); // Asumiendo que LoginModel tiene un campo 'telefono' de tipo int
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _nombre = null;
    _apellido = null;
    _telefono = null;
    notifyListeners();
  }
}