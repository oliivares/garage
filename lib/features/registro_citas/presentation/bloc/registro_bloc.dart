import 'package:app_garagex/services/cita_service.dart';
import 'package:flutter/material.dart';

class CitaBloc extends ChangeNotifier {
  final CitaService _citaService = CitaService();
  List<Map<String, dynamic>> _citas = [];
  Map<String, dynamic>? _citaSeleccionada;

  List<Map<String, dynamic>> get citas => _citas;
  Map<String, dynamic>? get citaSeleccionada => _citaSeleccionada;

  Future<void> cargarCitas() async {
    try {
      _citas = await _citaService.obtenerCitas();
      notifyListeners();
    } catch (e) {
      throw Exception("Error al cargar las citas: $e");
    }
  }

  Future<void> seleccionarCita(int id) async {
    try {
      _citaSeleccionada = await _citaService.obtenerCitaPorId(id);
      notifyListeners();
    } catch (e) {
      throw Exception("Error al seleccionar la cita: $e");
    }
  }

  void limpiarSeleccion() {
    _citaSeleccionada = null;
    notifyListeners();
  }
}
