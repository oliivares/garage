import '../entities/location_entity.dart';

abstract class MapRepository {
  Future<LocationEntity> searchLocation(String query);
}
