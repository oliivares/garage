import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';

class ZoomButtonsWidget extends StatelessWidget {
  const ZoomButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'zoom_in',
          foregroundColor: Colors.deepOrange,
          child: const Icon(Icons.add),
          onPressed: () {
            BlocProvider.of<MapBloc>(context).add(ZoomInEvent());
          },
        ),
        const SizedBox(height: 10),
        FloatingActionButton(
          heroTag: 'zoom_out',
          foregroundColor: Colors.deepOrange,
          child: const Icon(Icons.remove),
          onPressed: () {
            BlocProvider.of<MapBloc>(context).add(ZoomOutEvent());
          },
        ),
      ],
    );
  }
}
