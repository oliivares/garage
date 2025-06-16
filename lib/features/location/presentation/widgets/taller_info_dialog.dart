import 'package:app_garagex/features/location/presentation/screens/citas.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

class TallerInfoDialog extends StatelessWidget {
  final Taller taller;

  const TallerInfoDialog({required this.taller, super.key});

  void _llamar(BuildContext context, String numero) async {
    final Uri url = Uri(scheme: 'tel', path: numero);

    try {
      final bool launched = await launchUrl(url);
      if (!launched) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar la llamada')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al intentar llamar: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.deepOrange, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                taller.nombre,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(
                "${AppLocalizations.of(context)!.address}: ${taller.direccion}",
              ),
              if (taller.email != null) ...[
                const SizedBox(height: 8),
                Text("${AppLocalizations.of(context)!.email}: ${taller.email}"),
              ],
              ...[
                const SizedBox(height: 8),
                Text(
                  "${AppLocalizations.of(context)!.phone}: ${taller.telefono}",
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                () =>
                                    _llamar(context, taller.telefono as String),
                            icon: const Icon(Icons.phone),
                            label: Text(AppLocalizations.of(context)!.call),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          CitasScreen(tallerId: taller.id),
                                ),
                              );
                            },

                            icon: const Icon(Icons.calendar_today),
                            label: const Text('Citar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: null, // Deshabilitado
                      icon: const Icon(Icons.chat),
                      label: const Text('Contactar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade400,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
