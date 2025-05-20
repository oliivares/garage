import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = "http://10.0.2.2:8080/usuario";

  static Future<Map<String, dynamic>> loginUser({
    required String userName,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/login");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombreUsuario': userName, 'contrasenya': password}),
      );

      if (response.statusCode == 200 && response.body.startsWith('ey')) {
        return {
          "success": true,
          "message": "Inicio de sesión exitoso",
          "token": response.body,
        };
      } else {
        return {"success": false, "message": response.body};
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: ${e.toString()}",
      };
    }
  }

  static Future<Map<String, dynamic>> getUsuarioActual() async {
    final url = Uri.parse("$_baseUrl/getUsuarioActual");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "No hay token disponible"};
      }

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {"success": true, "usuario": data};
      } else {
        return {
          "success": false,
          "message": "Error al obtener usuario: ${response.body}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: ${e.toString()}",
      };
    }
  }

  static Future<Map<String, dynamic>> actualizarUsuario({
    required String nombre,
    required String nombreUsuario,
    required String email,
    required String telefono,
  }) async {
    final url = Uri.parse("$_baseUrl/update");

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {"success": false, "message": "No hay token disponible"};
      }

      final Map<String, dynamic> data = {
        "nombre": nombre,
        "nombreUsuario": nombreUsuario,
        "email": email,
        "telefono": int.tryParse(telefono) ?? 0,
      };

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final updatedUser = jsonDecode(response.body);
        return {"success": true, "usuario": updatedUser};
      } else {
        return {
          "success": false,
          "message": "Error al actualizar usuario: ${response.body}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: ${e.toString()}",
      };
    }
  }
}
