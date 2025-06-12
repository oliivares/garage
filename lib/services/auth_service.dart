import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static final String _baseUrl = StaticData.baseUrl;

  static Future<Map<String, dynamic>> loginUser({
    required String userName,
    required String password,
  }) async {
    final url = Uri.parse("$_baseUrl/usuario/login");

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
    final url = Uri.parse("$_baseUrl/usuario/getUsuarioActual");

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
    required String rol, // nuevo parámetro
  }) async {
    if (!email.endsWith("@gmail.com")) {
      return {
        "success": false,
        "message": "El correo debe terminar en @gmail.com",
      };
    }

    if (telefono.length < 9 || int.tryParse(telefono) == null) {
      return {
        "success": false,
        "message":
            "El número de teléfono debe tener al menos 9 dígitos válidos",
      };
    }

    final url = Uri.parse("$_baseUrl/usuario/update");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      return {"success": false, "message": "No hay token disponible"};
    }

    final data = {
      "nombre": nombre,
      "nombreUsuario": nombreUsuario,
      "email": email,
      "telefono": int.parse(telefono),
      "rol": rol, // incluir el rol
    };

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        return {"success": true, "usuario": jsonDecode(response.body)};
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

  static Future<Map<String, dynamic>> cambiarContrasena(
    String actual,
    String nueva,
  ) async {
    final token = await _getToken(); // Obtener token

    if (token == null) {
      return {"success": false, "message": "No hay token disponible"};
    }

    final response = await http.put(
      Uri.parse("$_baseUrl/usuario/cambiar-contrasena"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"actual": actual, "nueva": nueva}),
    );

    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      return {"success": false, "message": jsonDecode(response.body)};
    }
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
