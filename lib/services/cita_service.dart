import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CitaService {
  final String baseUrl = '${StaticData.baseUrl}/cita';

  Future<List<Map<String, dynamic>>> obtenerCitas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error al obtener las citas: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> obtenerCitaPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener la cita: ${response.statusCode}");
    }
  }

  static Future<List<Map<String, dynamic>>> obtenerCitasPorUsuario(int usuarioId) async {
    final url = Uri.parse('${StaticData.baseUrl}/cita/usuario/actual');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

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

  static Future<Map<String, dynamic>> agregarCita(Map<String, dynamic> citaData) async {
    final url = Uri.parse("${StaticData.baseUrl}/cita");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "🔒 Token no disponible"};
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(citaData),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {"success": true, "cita": data};
        } catch (e) {
          return {
            "success": false,
            "message": "La respuesta no es JSON válido: ${response.body}",
          };
        }
      } else {
        try {
          final errorData = jsonDecode(response.body);
          return {
            "success": false,
            "message": errorData["message"] ?? "Error desconocido",
          };
        } catch (_) {
          return {
            "success": false,
            "message": "🚫 Error ${response.statusCode}: Respuesta inválida",
          };
        }
      }
    } catch (e) {
      return {"success": false, "message": "🌐 Error de conexión: $e"};
    }
  }

  static Future<Map<String, dynamic>> eliminarCita(int id) async {
    final url = Uri.parse('${StaticData.baseUrl}/cita/$id');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "🔒 Token no disponible"};
      }

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        return {
          "success": false,
          "message": "Error ${response.statusCode}: ${response.body}",
        };
      }
    } catch (e) {
      return {"success": false, "message": "🌐 Error: $e"};
    }
  }
}
