import 'dart:ui';
import 'package:app_garagex/services/cita_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitasBloc {
  VoidCallback? onRefresh;

  CitasBloc({this.onRefresh});

  Future<int?> obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuarioId');
  }

  Future<List<Map<String, dynamic>>> cargarCitas(int usuarioId) async {
    return await CitaService.obtenerCitasPorUsuario(usuarioId);
  }

  Future<Map<String, dynamic>> eliminarCita(int id) async {
    return await CitaService.eliminarCita(id);
  }

  void refresh() {
    if (onRefresh != null) {
      onRefresh!();
    }
  }
}