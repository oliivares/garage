import 'package:app_garagex/features/location/domain/entities/location_entity.dart';

abstract class MapEvent {}

class SearchLocationEvent extends MapEvent {
  final String query;

  SearchLocationEvent(this.query);
}

class ZoomInEvent extends MapEvent {}

class ZoomOutEvent extends MapEvent {}

class ResetToUserLocationEvent extends MapEvent {
  final LocationEntity userLocation;

  ResetToUserLocationEvent({required this.userLocation});
}
