import 'package:latlong2/latlong.dart'; // 👈 usa latlong2

class LocationEntity {
  final LatLng coordinates;
  final String name;

  LocationEntity({required this.coordinates, required this.name});
}
