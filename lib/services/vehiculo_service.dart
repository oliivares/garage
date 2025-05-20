import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VehiculoService {
  static const String baseUrl = 'http://10.0.2.2:8080/vehiculo';

  /// Agrega un nuevo vehículo
  static Future<Map<String, dynamic>> agregarVehiculo(
    Map<String, dynamic> vehiculoData,
  ) async {
    final url = Uri.parse(baseUrl);

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
        body: jsonEncode(vehiculoData),
      );

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return {"success": true, "vehiculo": data};
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

  /// Obtiene todos los vehículos de un usuario por ID
  static Future<List<Map<String, dynamic>>> obtenerVehiculosDeUsuario(
    int usuarioId,
  ) async {
    final url = Uri.parse('$baseUrl/usuario/$usuarioId');

    try {
      final response = await http.get(url);

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

  static Future<Map<String, dynamic>> eliminarVehiculo(int id) async {
    final url = Uri.parse('$baseUrl/$id');

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

  static Future<Map<String, dynamic>> editarVehiculo(
    Map<String, dynamic> vehiculoData,
  ) async {
    final url = Uri.parse('$baseUrl/${vehiculoData["id"]}');

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "🔒 Token no disponible"};
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(vehiculoData),
      );

      if (response.statusCode == 200) {
        return {"success": true};
      } else {
        final errorData = jsonDecode(response.body);
        return {
          "success": false,
          "message": errorData["message"] ?? "Error al editar",
        };
      }
    } catch (e) {
      return {"success": false, "message": "🌐 Error: $e"};
    }
  }
}
