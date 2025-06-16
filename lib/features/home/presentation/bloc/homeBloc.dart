import 'package:flutter/material.dart';
import 'package:app_garagex/services/auth_service.dart';
import 'package:app_garagex/features/location/presentation/bloc/servicio_citas.dart';

class HomeController extends ChangeNotifier {
  Map<String, dynamic>? usuario;
  List<Map<String, dynamic>> citas = [];
  bool cargando = true;
  DateTime? selectedDate;

  Future<void> cargarDatos(BuildContext context) async {
    final response = await AuthService.getUsuarioActual();
    if (response['success']) {
      usuario = response['usuario'];
      citas = await CitaService.obtenerCitasPorUsuarioActual();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error desconocido')),
      );
    }
    cargando = false;
    notifyListeners();
  }

  Future<void> seleccionarFecha(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder:
          (context, child) => Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme.light(
                primary: Colors.deepOrangeAccent,
              ),
            ),
            child: child!,
          ),
    );

    if (picked != null) {
      selectedDate = picked;
      notifyListeners();
    }
  }
}
