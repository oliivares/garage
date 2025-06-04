import 'package:app_garagex/features/vehiculo/presentation/bloc/vehiculo_bloc.dart';
import 'package:app_garagex/features/vehiculo/presentation/screens/vehiculo_mod.dart';
import 'package:app_garagex/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/services/vehiculo_service.dart';

class VehiculoItem extends StatelessWidget {
  final Map<String, dynamic> vehiculo;
  final VehiculosBloc controller;

  const VehiculoItem({
    super.key,
    required this.vehiculo,
    required this.controller,
  });

  void _confirmarEliminacion(BuildContext context) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
title: Text('${AppLocalizations.of(context)!.delete} ${AppLocalizations.of(context)!.vehicle}'),
            content: Text(
AppLocalizations.of(context)!.deleteVehicle            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child:  Text(
                  AppLocalizations.of(context)!.delete,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmacion == true) {
      final response = await VehiculoService.eliminarVehiculo(vehiculo['id']);
      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text(AppLocalizations.of(context)!.deleteConfirmation)),
        );
        controller.refresh(); // Refrescar lista
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: ${response['message']}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9), // Blanco suave
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.directions_car, color: Colors.deepOrange),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(context)!.licensePlate}: "${vehiculo['matricula']}"',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14, // Reducido
              ),
            ),
            Text(
              '${AppLocalizations.of(context)!.brand}: "${vehiculo['marca']}"',
              style: const TextStyle(
                fontSize: 12, // Reducido
                color: Colors.black,
              ),
            ),
          ],
        ),

        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => EditarVehiculoScreen(
                          vehiculo: vehiculo,
                          onSuccess: controller.refresh,
                        ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmarEliminacion(context),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => VehiculoDetalleDialog(vehiculo: vehiculo),
          );
        },
      ),
    );
  }
}

class VehiculoDetalleDialog extends StatelessWidget {
  final Map<String, dynamic> vehiculo;

  const VehiculoDetalleDialog({super.key, required this.vehiculo});

  Widget _detalleVehiculo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${label.toLowerCase()}: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text('"$value"')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Detalles del Vehículo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _detalleVehiculo("Matrícula", vehiculo["matricula"].toString()),
            _detalleVehiculo("Marca", vehiculo["marca"].toString()),
            _detalleVehiculo("Motor", vehiculo["motor"].toString()),
            _detalleVehiculo(
              "Potencia",
              "${vehiculo["potencia"].toString()} CV",
            ),
            _detalleVehiculo("Año", vehiculo["anyo"].toString()),
          ],
        ),
      ),
    );
  }
}
