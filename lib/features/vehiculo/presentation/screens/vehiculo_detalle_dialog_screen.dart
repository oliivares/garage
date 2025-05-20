import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehiculoDetalleDialog extends StatelessWidget {
  final VehiculoDetalleLogic logic;
  final VoidCallback? onEditar;

  const VehiculoDetalleDialog({super.key, required this.logic, this.onEditar});

  Widget _detalleVehiculo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detalles = logic.obtenerDetalles(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height:
            MediaQuery.of(context).size.height *
            0.5, // Fijamos el alto del diálogo
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Encabezado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.vehicleDetails,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children:
                      detalles
                          .map(
                            (detalle) => _detalleVehiculo(
                              detalle["label"]!,
                              detalle["value"]!,
                            ),
                          )
                          .toList(),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Botón Editar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  if (onEditar != null) {
                    onEditar!();
                  }
                },
                icon: const Icon(Icons.edit),
                label: Text(AppLocalizations.of(context)!.edits),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehiculoDetalleLogic {
  final Map<String, dynamic> vehiculo;

  VehiculoDetalleLogic(this.vehiculo);

  List<Map<String, String>> obtenerDetalles(BuildContext context) {
    return [
      {
        "label": AppLocalizations.of(context)!.licensePlate,
        "value": vehiculo["matricula"].toString(),
      },
      {
        "label": AppLocalizations.of(context)!.brand,
        "value": vehiculo["marca"].toString(),
      },
      {
        "label": AppLocalizations.of(context)!.motor,
        "value": vehiculo["motor"].toString(),
      },
      {
        "label": AppLocalizations.of(context)!.power,
        "value": "${vehiculo["potencia"]} CV",
      },
      {
        "label": AppLocalizations.of(context)!.year,
        "value": vehiculo["anyo"].toString(),
      },
    ];
  }
}
