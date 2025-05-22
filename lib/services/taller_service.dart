import 'dart:convert';
import 'package:app_garagex/features/location/data/models/taller.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TalleresService {
  final String baseUrl;

  TalleresService({required this.baseUrl});

  Future<List<Taller>> obtenerTalleres() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('http://10.0.2.2:8080/taller'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => Taller.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los talleres');
    }
  }
}
