import 'package:app_garagex/features/location/domain/entities/location_entity.dart';
import 'package:app_garagex/features/location/domain/repositories/map_repositories.dart';

class SearchLocationUseCase {
  final MapRepository repository;

  SearchLocationUseCase(this.repository);

  Future<LocationEntity> call(String query) => repository.searchLocation(query);
}
