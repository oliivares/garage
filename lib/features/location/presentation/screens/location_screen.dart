import 'package:app_garagex/features/location/data/repositories/map_repository_imp.dart';
import 'package:app_garagex/features/location/domain/entities/location_entity.dart';
import 'package:app_garagex/features/location/domain/usercases/search_location_usercase.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_bloc.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_event.dart';
import 'package:app_garagex/features/location/presentation/bloc/map_state.dart';
import 'package:app_garagex/features/location/presentation/widgets/search_bar.dart';
import 'package:app_garagex/features/location/presentation/widgets/taller_info_dialog.dart';
import 'package:app_garagex/features/location/presentation/widgets/zoom_botton.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';
import 'package:app_garagex/services/taller_service.dart';
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
  List<Taller> _talleres = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _cargarTalleres();
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

  Future<void> _cargarTalleres() async {
    try {
      final talleresService = TalleresService(baseUrl: 'http://10.0.2.2:8080');
      final talleres = await talleresService.obtenerTalleres();
      print("Cantidad de talleres recibidos: ${talleres.length}");
      for (var t in talleres) {
        print("Taller: ${t.nombre} - (${t.latitud}, ${t.longitud})");
      }

      setState(() {
        _talleres = talleres;
      });
    } catch (e) {
      print("❌ Error cargando talleres: $e");
    }
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
                      ..._talleres.map((taller) {
                        return Marker(
                          point: LatLng(taller.latitud, taller.longitud),
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => TallerInfoDialog(taller: taller),
                              );
                            },

                            child: const Icon(
                              Icons.build,
                              color: Colors.orange,
                              size: 30,
                            ),
                          ),
                        );
                      }),
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
                context.read<MapBloc>().add(
                  ResetToUserLocationEvent(userLocation: userLocation),
                );
              }
            },
            child: const Icon(Icons.my_location),
            backgroundColor: Colors.white,
            foregroundColor: Colors.deepOrange,
          ),
          const SizedBox(height: 10),
          ZoomButtonsWidget(mapController: _mapController),
        ],
      ),
    );
  }
}
