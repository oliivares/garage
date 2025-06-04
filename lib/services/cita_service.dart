import 'dart:convert';
import 'package:http/http.dart' as http;

class CitaService {
  final String baseUrl = 'http://localhost:8080/citas';

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
}
