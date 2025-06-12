import 'dart:convert';
import 'package:app_garagex/features/location/domain/repositories/map_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../../domain/entities/location_entity.dart';

class MapRepositoryImpl implements MapRepository {
  final http.Client client;

  MapRepositoryImpl({required this.client});

  @override
  Future<LocationEntity> searchLocation(String query) async {
    final baseUrl = 'https://nominatim.openstreetmap.org/search';
    final url = Uri.parse(
      '$baseUrl?q=${Uri.encodeQueryComponent(query)}&format=json&limit=1',
    );

    final response = await client.get(
      url,
      headers: {'User-Agent': 'AppGarageX/1.0 (contacto@example.com)'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        final result = data[0];
        return LocationEntity(
          coordinates: LatLng(
            double.parse(result['lat']),
            double.parse(result['lon']),
          ),
          name: result['display_name'],
        );
      } else {
        // Retornar null o lanzar excepción controlada para que el UI lo maneje
        throw Exception('No se encontraron resultados para "$query".');
      }
    } else {
      throw Exception('Error en la búsqueda: ${response.statusCode}');
    }
  }
}
