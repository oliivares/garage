import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_garagex/services/vehiculo_service.dart';

class VehiculosBloc {
  VoidCallback? onRefresh;

  VehiculosBloc({this.onRefresh});

  Future<int?> obtenerUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('usuarioId');
  }

  Future<List<Map<String, dynamic>>> cargarVehiculos(int usuarioId) async {
    return await VehiculoService.obtenerVehiculosDeUsuario(usuarioId);
  }

  Future<Map<String, dynamic>> eliminarVehiculo(int id) async {
    return await VehiculoService.eliminarVehiculo(id);
  }

  void refresh() {
    if (onRefresh != null) {
      onRefresh!();
    }
  }
}
