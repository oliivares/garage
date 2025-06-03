// zoom_botton.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import 'package:flutter_map/flutter_map.dart';

class ZoomButtonsWidget extends StatelessWidget {
  final MapController mapController;

  const ZoomButtonsWidget({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FloatingActionButton.small(
          heroTag: 'zoom_in',
          onPressed: () {
            final currentCenter = mapController.camera.center;
            context.read<MapBloc>().add(UpdateMapCenterEvent(currentCenter));
            context.read<MapBloc>().add(ZoomInEvent());
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
          child: const Icon(Icons.zoom_in),
        ),
        const SizedBox(height: 8),
        FloatingActionButton.small(
          heroTag: 'zoom_out',
          onPressed: () {
            final currentCenter = mapController.camera.center;
            context.read<MapBloc>().add(UpdateMapCenterEvent(currentCenter));
            context.read<MapBloc>().add(ZoomOutEvent());
          },
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepOrange,
          child: const Icon(Icons.zoom_out),
        ),
      ],
    );
  }
}
