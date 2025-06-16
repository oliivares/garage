import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CitaService {
  static final String baseUrl = '${StaticData.baseUrl}/cita';

  // Obtener todas las citas
  static Future<List<Map<String, dynamic>>> obtenerCitas() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.cast<Map<String, dynamic>>();
    } else {
      throw Exception("Error al obtener las citas: ${response.statusCode}");
    }
  }

  // Obtener una cita por ID
  static Future<Map<String, dynamic>> obtenerCitaPorId(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error al obtener la cita: ${response.statusCode}");
    }
  }

  // Obtener citas por usuario actual (usa token guardado en SharedPreferences)
  static Future<List<Map<String, dynamic>>> obtenerCitasPorUsuario(
    int usuarioId,
  ) async {
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

  // Crear cita (recibe campos separados)
  static Future<Map<String, dynamic>> crearCita({
    required String descripcion,
    required DateTime fechaHora,
    required int vehiculoId,
    required int tallerId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'descripcion': descripcion,
        'fechaHoraCita': fechaHora.toIso8601String(),
        'estado': 'PENDIENTE',
        'vehiculo': {'id': vehiculoId},
        'taller': {'id': tallerId},
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': 'Cita creada correctamente',
        'data': jsonDecode(response.body),
      };
    } else {
      return {
        'success': false,
        'message': 'Error al crear cita: ${response.body}',
      };
    }
  }

  // Agregar cita (recibe un Map con toda la data)
  static Future<Map<String, dynamic>> agregarCita(
    Map<String, dynamic> citaData,
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
        body: jsonEncode(citaData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
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

  // Eliminar cita por ID
  static Future<Map<String, dynamic>> eliminarCita(int id) async {
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
}
