import 'package:app_garagex/features/location/data/repositories/map_repository_imp.dart';
import 'package:app_garagex/features/location/domain/entities/location_entity.dart';
import 'package:app_garagex/features/location/domain/usercases/search_location_usercase.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_bloc.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_event.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_state.dart';
import 'package:app_garagex/features/location/presentation/widgets/search_bar.dart';
import 'package:app_garagex/features/location/presentation/widgets/zoom_botton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocalizacionScreen extends StatelessWidget {
  const LocalizacionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchLocationUseCase = SearchLocationUseCase(
      MapRepositoryImpl(client: http.Client()),
    );

    return BlocProvider(
      create: (_) => MapBloc(searchLocationUseCase: searchLocationUseCase),
      child: const _MapScreenBody(),
    );
  }
}

class _MapScreenBody extends StatefulWidget {
  const _MapScreenBody();

  @override
  State<_MapScreenBody> createState() => _MapScreenBodyState();
}

class _MapScreenBodyState extends State<_MapScreenBody> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    _mapController.move(_currentLocation!, 15.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MapBloc, MapState>(
        listener: (context, state) {
          if (state is MapLoaded) {
            _mapController.move(state.center.coordinates, state.zoom);
          } else if (state is MapError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${state.failure}')));
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: state.center.coordinates,
                  initialZoom: state.zoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  ),
                  MarkerLayer(
                    markers: [
                      if (state.searchLocation != null)
                        Marker(
                          point: state.searchLocation!.coordinates,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.place,
                            size: 60,
                            color: Colors.red,
                          ),
                        ),
                      if (_currentLocation != null)
                        Marker(
                          point: _currentLocation!,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              Positioned(
                top: 80,
                left: 16,
                right: 16,
                child: SearchBarWidget(
                  onSearch: (query) {
                    context.read<MapBloc>().add(SearchLocationEvent(query));
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'current_location',
            onPressed: () {
              if (_currentLocation != null) {
                final userLocation = LocationEntity(
                  coordinates: _currentLocation!,
                  name: "Mi Ubicación",
                );

                // Mueve el mapa visualmente y actualiza el Bloc
                context.read<MapBloc>().add(
                  ResetToUserLocationEvent(userLocation: userLocation),
                );
              }
            },
            child: const Icon(Icons.my_location),
            foregroundColor: Colors.deepOrange,
          ),

          const SizedBox(height: 10),
          const ZoomButtonsWidget(),
        ],
      ),
    );
  }
}
