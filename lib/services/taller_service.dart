import 'dart:convert';
import 'package:app_garagex/features/location/data/models/taller.dart';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TalleresService {
  final String baseUrl;
  final url = StaticData.baseUrl;

  TalleresService({required this.baseUrl});

  Future<List<Taller>> obtenerTalleres() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await http.get(
      Uri.parse('$url/taller'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      return decoded.map((e) => Taller.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar los talleres');
    }
  }

  Future<bool> actualizarTaller(Taller taller) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? '';

    final response = await http.put(
      Uri.parse('$url/taller/${taller.id}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nombre': taller.nombre,
        'direccion': taller.direccion,
        'telefono': taller.telefono,
        'email': taller.email,
        'latitud': taller.latitud,
        'longitud': taller.longitud,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Error al actualizar el taller: ${response.body}');
    }
  }
}
