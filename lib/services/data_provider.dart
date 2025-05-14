import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  int _soglia = 80;
  int get soglia => _soglia;

  Future<void> aggiornaSoglia(int nuovaSoglia) async {
    _soglia = nuovaSoglia;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('soglia', nuovaSoglia);
  }

  Future<void> caricaSoglia() async {
    final prefs = await SharedPreferences.getInstance();
    _soglia = prefs.getInt('soglia') ?? 80;
    notifyListeners();
  }
}