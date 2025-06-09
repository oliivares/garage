import 'package:app_garagex/features/location/domain/entities/location_entity.dart';
import 'package:app_garagex/features/location/domain/usercases/search_location_usercase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final SearchLocationUseCase searchLocationUseCase;

  MapBloc({required this.searchLocationUseCase}) : super(MapInitial()) {
    on<SearchLocationEvent>((event, emit) async {
      try {
        final location = await searchLocationUseCase(event.query);
        emit(MapLoaded(center: location, zoom: 15, searchLocation: location));
      } catch (e) {
        emit(MapError(Exception("Fallo al buscar: ${e.toString()}")));
      }
    });

    on<ResetToUserLocationEvent>((event, emit) {
      print("📍 ResetToUserLocationEvent recibido");
      emit(
        MapLoaded(center: event.userLocation, zoom: 15, searchLocation: null),
      );
    });

    // 👉 Zoom In
    on<ZoomInEvent>((event, emit) {
      if (state is MapLoaded) {
        final current = state as MapLoaded;
        final newZoom = (current.zoom + 1).clamp(2.0, 18.0);

        emit(
          MapLoaded(
            center: current.center,
            zoom: newZoom,
            searchLocation: current.searchLocation,
          ),
        );
      }
    });

    on<ZoomOutEvent>((event, emit) {
      if (state is MapLoaded) {
        final current = state as MapLoaded;
        final newZoom = (current.zoom - 1).clamp(2.0, 18.0);

        emit(
          MapLoaded(
            center: current.center, // 👈 mantiene centro actual
            zoom: newZoom,
            searchLocation: current.searchLocation,
          ),
        );
      }
    });

    on<UpdateMapCenterEvent>((event, emit) {
      if (state is MapLoaded) {
        final current = state as MapLoaded;
        emit(
          MapLoaded(
            center: LocationEntity(coordinates: event.newCenter, name: ''),
            zoom: current.zoom,
            searchLocation: current.searchLocation,
          ),
        );
      }
    });
  }
}
