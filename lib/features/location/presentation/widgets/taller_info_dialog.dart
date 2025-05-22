import 'package:flutter/material.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';

class TallerInfoDialog extends StatelessWidget {
  final Taller taller;

  const TallerInfoDialog({required this.taller, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          // para que tome el tamaño justo del contenido
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taller.nombre,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text("Dirección: ${taller.direccion}"),
              if (taller.telefono != null) ...[
                const SizedBox(height: 8),
                Text("Teléfono: ${taller.telefono}"),
              ],
              if (taller.email != null) ...[
                const SizedBox(height: 8),
                Text("Email: ${taller.email}"),
              ],
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cerrar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
