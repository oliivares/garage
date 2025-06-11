import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class UsuarioSearchService {
  final http.Client client;

  UsuarioSearchService({required this.client});

  // Busca usuarios por nombre de usuario (retorna lista de strings)
  Future<List<String>> buscarUsuariosPorNombreUsuario(String texto) async {
    final uri = Uri.parse(
      "http://10.0.2.2:8080/usuario/buscar-por-nombre-usuario?texto=$texto",
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList
          .map<String>((item) => item['nombreUsuario'] as String)
          .toList();
    } else {
      throw Exception("Error en búsqueda: ${response.statusCode}");
    }
  }

  // Obtiene los datos completos de un usuario
  Future<Map<String, dynamic>> obtenerUsuarioPorNombreUsuario(
    String nombre,
  ) async {
    final uri = Uri.parse("http://10.0.2.2:8080/usuario/$nombre");
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception("Error al obtener usuario: ${response.statusCode}");
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
