import 'package:flutter/material.dart';

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
    final detalles = logic.obtenerDetalles();

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

            // Detalles en una lista desplazable
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
                label: const Text("Editar"),
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

  List<Map<String, String>> obtenerDetalles() {
    return [
      {"label": "Matrícula", "value": vehiculo["matricula"].toString()},
      {"label": "Marca", "value": vehiculo["marca"].toString()},
      {"label": "Motor", "value": vehiculo["motor"].toString()},
      {"label": "Potencia", "value": "${vehiculo["potencia"]} CV"},
      {"label": "Año", "value": vehiculo["anyo"].toString()},
    ];
  }
}
