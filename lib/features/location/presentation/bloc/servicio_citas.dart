import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CitaService {
  static String baseUrl = StaticData.baseUrl;
  static Future<String> crearCita(
    Map<String, dynamic> citaData,
    String token,
  ) async {
    final url = Uri.parse('$baseUrl/cita');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(citaData),
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      try {
        final errorBody = jsonDecode(response.body);
        final mensajeError = errorBody['mensaje'] ?? 'Error desconocido';
        throw Exception(mensajeError);
      } catch (_) {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    }
  }

  static Future<List<Map<String, dynamic>>>
  obtenerCitasPorUsuarioActual() async {
    final url = Uri.parse('${StaticData.baseUrl}/cita/usuario/actual');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        print("🔒 Token no disponible");
        return [];
      }

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      print("🔍 GET $url");
      print("📦 Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.cast<Map<String, dynamic>>();
      } else {
        print("❌ Error ${response.statusCode}: ${response.body}");
        return [];
      }
    } catch (e) {
      print("💥 Error en la solicitud: ${e.runtimeType} - $e");
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerCitasDeUsuario(
    int userId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final url = Uri.parse("${StaticData.baseUrl}/cita/$userId");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic> && data.containsKey('citas')) {
        final List<dynamic> citas = data['citas'];
        return citas.cast<Map<String, dynamic>>();
      } else {
        // Estructura inesperada
        return [];
      }
    } else {
      return [];
    }
  }
}
