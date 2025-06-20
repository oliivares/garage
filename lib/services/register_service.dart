import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;

class InsertarUsuarioService {
  static final String _url = "${StaticData.baseUrl}/usuario/register";

  static Future<Map<String, dynamic>> insertarUsuario({
    required String nombre,
    required String usuario,
    required String contrasenya,
    required String correo,
    String? telefono,
  }) async {
    final Map<String, dynamic> data = {
      "nombre": nombre,
      "nombreUsuario": usuario,
      "email": correo,
      "contrasenya": contrasenya,
      "telefono": telefono != null ? int.tryParse(telefono) ?? 0 : 0,
      "rol": "CLIENTE",
    };

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      String responseBody = response.body.toString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {"success": true, "message": "Usuario registrado correctamente"};
      } else if (response.statusCode == 302) {
        return {"success": false, "message": "Usuario con valores ya registrados"};
      } else {
        return {"success": false, "message": responseBody};
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error de conexión: ${e.toString()}",
      };
    }
  }
}
