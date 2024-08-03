import 'package:flutter/material.dart';

class ButtonVisibility with ChangeNotifier {
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
