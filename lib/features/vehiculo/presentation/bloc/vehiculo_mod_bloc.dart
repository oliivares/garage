import 'package:flutter/material.dart';
import 'package:app_garagex/services/vehiculo_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditarVehiculoBloc {
  final TextEditingController matriculaController = TextEditingController();
  final TextEditingController marcaController = TextEditingController();
  final TextEditingController motorController = TextEditingController();
  final TextEditingController potenciaController = TextEditingController();
  final TextEditingController anyoController = TextEditingController();

  void inicializarCamposVehiculo(Map<String, dynamic> vehiculo) {
    matriculaController.text = vehiculo["matricula"] ?? '';
    marcaController.text = vehiculo["marca"] ?? '';
    motorController.text = vehiculo["motor"] ?? '';
    potenciaController.text = vehiculo["potencia"]?.toString() ?? '';
    anyoController.text = vehiculo["anyo"]?.toString() ?? '';
  }

  Future<Map<String, dynamic>> editarVehiculo(
    Map<String, dynamic>? vehiculoOriginal,
  ) async {
    if (vehiculoOriginal == null) {
      throw Exception("vehiculoOriginal no puede ser null");
    }

    final prefs = await SharedPreferences.getInstance();
    final usuarioId = prefs.getInt("usuarioId");

    if (usuarioId == null) {
      throw Exception(
        "El ID del usuario no está disponible en SharedPreferences",
      );
    }

    final data = {
      "id": vehiculoOriginal["id"],
      "matricula": matriculaController.text.trim(),
      "marca": marcaController.text.trim(),
      "motor": motorController.text.trim(),
      "potencia": int.tryParse(potenciaController.text.trim()) ?? 0,
      "anyo": int.tryParse(anyoController.text.trim()) ?? 0,
      "usuario": {"id": usuarioId},
    };

    return await VehiculoService.editarVehiculo(data);
  }

  void dispose() {
    matriculaController.dispose();
    marcaController.dispose();
    motorController.dispose();
    potenciaController.dispose();
    anyoController.dispose();
  }
}
