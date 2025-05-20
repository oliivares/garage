import 'package:latlong2/latlong.dart';
import '../../domain/entities/location_entity.dart';

abstract class MapState {
  LocationEntity get center;
  double get zoom;
  LocationEntity? get searchLocation;
}

class MapInitial extends MapState {
  @override
  LocationEntity get center =>
      LocationEntity(coordinates: LatLng(0, 0), name: "Centro inicial");

  @override
  double get zoom => 2;

  @override
  LocationEntity? get searchLocation => null;
}

class MapLoaded extends MapState {
  @override
  final LocationEntity center;
  @override
  final double zoom;
  @override
  final LocationEntity? searchLocation;

  MapLoaded({required this.center, required this.zoom, this.searchLocation});
}

class MapError extends MapState {
  final Exception failure;

  MapError(this.failure);

  @override
  LocationEntity get center =>
      LocationEntity(coordinates: LatLng(0, 0), name: "Error");

  @override
  double get zoom => 2;

  @override
  LocationEntity? get searchLocation => null;
}
