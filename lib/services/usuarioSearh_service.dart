import 'dart:convert';
import 'dart:io';

import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioSearchService {
  final http.Client client;
  final url = StaticData.baseUrl;

  UsuarioSearchService({required this.client});

  Future<List<String>> buscarUsuariosPorNombreUsuario(String texto) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.getString('nombreUsuario');

    final uri = Uri.parse(
      "$url/usuario/buscar-por-nombre-usuario?texto=$texto",
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .where(
            (item) =>
                item['rol'] != 'ADMINISTRADOR' &&
                item['nombreUsuario'] != "admin",
          )
          .map<String>((item) => item['nombreUsuario'] as String)
          .toList();
    } else {
      throw Exception("Error en búsqueda: ${response.statusCode}");
    }
  }

  Future<Map<String, dynamic>> cambiarRolUsuario({
    required String nombreUsuario,
    required String nuevoRol,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return {"success": false, "message": "No hay token disponible"};
    }

    final uri = Uri.parse(
      "$url/usuario/cambiar-rol?nombreUsuario=$nombreUsuario&nuevoRol=$nuevoRol",
    );

    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return {"success": true, "message": response.body};
    } else {
      return {
        "success": false,
        "message":
            response.body.isNotEmpty
                ? response.body
                : "Error al cambiar el rol",
      };
    }
  }

  Future<Map<String, dynamic>> actualizarUsuario({
    required String nombre,
    required String nombreUsuario,
    required String email,
    required String telefono,
    required String rol,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      return {"success": false, "message": "No hay token disponible"};
    }

    final uri = Uri.parse("$url/usuario/update");

    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "nombre": nombre,
        "nombreUsuario": nombreUsuario,
        "email": email,
        "telefono": int.tryParse(telefono),
        "rol": rol,
      }),
    );

    if (response.statusCode == 200) {
      return {"success": true};
    } else {
      dynamic error;
      try {
        error = jsonDecode(response.body);
      } catch (e) {
        error = response.body; // texto plano
      }

      return {
        "success": false,
        "message": error is String ? error : error["message"] ?? "Error",
      };
    }
  }

  Future<Map<String, dynamic>> obtenerUsuarioPorNombreUsuario(
    String nombreUsuario,
  ) async {
    final uri = Uri.parse('$url/usuario/query?nombreUsuario=$nombreUsuario');

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception("No hay token disponible");
    }

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> usuarios = jsonDecode(response.body);

      if (usuarios.isNotEmpty) {
        return usuarios.first;
      } else {
        throw Exception("Usuario no encontrado");
      }
    } else {
      throw Exception("Error al obtener el usuario: ${response.statusCode}");
    }
  }
}

// Cliente HTTP con soporte para cookies
IOClient createIOClient() {
  final httpClient =
      HttpClient()
        ..maxConnectionsPerHost = 5
        ..badCertificateCallback =
            (X509Certificate cert, String host, int port) =>
                true; // Solo para desarrollo local

  return IOClient(httpClient);
}
