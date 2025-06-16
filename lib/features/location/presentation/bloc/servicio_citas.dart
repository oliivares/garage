import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;

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
}
