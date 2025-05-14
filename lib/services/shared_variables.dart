import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SharedVariables extends ChangeNotifier {
    static double soglia = 50.0; // Valore predefinito della soglia
  static bool superata = false; // Indica se la soglia è stata superata
  bool _sogliaSuperata = false;
  bool _provam1 = false;
  bool _provam2 = false;
  bool _provam3 = false;

  // Getter
  bool get sogliaSuperata => _sogliaSuperata;
  bool get provam1 => _provam1;
  bool get provam2 => _provam2;
  bool get provam3 => _provam3;

  // Setter
  set sogliaSuperata(bool value) {
    if (_sogliaSuperata != value) {
      _sogliaSuperata = value;
      notifyListeners();
    }
  }

  set provam1(bool value) {
    if (_provam1 != value) {
      _provam1 = value;
      notifyListeners();
    }
  }

  set provam2(bool value) {
    if (_provam2 != value) {
      _provam2 = value;
      notifyListeners();
    }
  }

  set provam3(bool value) {
    if (_provam3 != value) {
      _provam3 = value;
      notifyListeners();
    }
  }
}

class EspService {
  static const String espIp = 'http://192.168.4.1';

  static Future<void> activatePin(int pinNumber) async {
    final url = Uri.parse('$espIp/pin$pinNumber');
    try {
      final response = await http.get(url);
      if (response.statusCode == 204) {
        print('Pin $pinNumber attivato correttamente.');
      } else {
        print('Errore HTTP (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('Errore di connessione: $e');
    }
  }
}