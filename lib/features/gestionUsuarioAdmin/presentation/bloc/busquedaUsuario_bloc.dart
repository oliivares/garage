import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_garagex/services/usuarioSearh_service.dart';

class BuscarUsuarioController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final UsuarioSearchService searchService;

  List<String> sugerencias = [];
  bool loading = false;
  String rolActualUsuario = '';

  BuscarUsuarioController({required this.searchService}) {
    _loadRolActualUsuario();
  }

  void _loadRolActualUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("usuario");
    if (userJson != null) {
      final user = jsonDecode(userJson);
      rolActualUsuario = user['rol'] ?? '';
      notifyListeners();
    }
  }

  void onChanged(String query) async {
    if (query.length < 2) {
      sugerencias = [];
      notifyListeners();
      return;
    }

    loading = true;
    notifyListeners();

    try {
      final resultados = await searchService.buscarUsuariosPorNombreUsuario(
        query,
      );
      sugerencias = resultados;
    } catch (e) {
      debugPrint("ERROR EN BUSQUEDA: $e");
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> obtenerUsuarioCompleto(String username) async {
    try {
      return await searchService.obtenerUsuarioPorNombreUsuario(username);
    } catch (e) {
      debugPrint("Error al obtener usuario completo: $e");
      rethrow;
    }
  }
}
