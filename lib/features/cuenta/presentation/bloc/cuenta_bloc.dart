import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_garagex/features/login/presentation/screens/login_screen.dart';

class CuentaController {
  Future<void> cerrarSesion(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<String> obtenerIdiomaActual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCode') ?? 'es';
  }
}
