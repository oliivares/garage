import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CitaService {
  static String baseUrl = '${StaticData.baseUrl}/cita';
}
