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
              SizedBox(height: 12),
              Text(
                "${AppLocalizations.of(context)!.address}: ${taller.direccion}",
              ),
              if (taller.email != null) ...[
                const SizedBox(height: 8),
                Text("${AppLocalizations.of(context)!.email}: ${taller.email}"),
              ],
              if (taller.telefono != null) ...[
                const SizedBox(height: 8),
                Text(
                  "${AppLocalizations.of(context)!.phone}: ${taller.telefono}",
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _llamar(context, taller.telefono!),
                  icon: const Icon(Icons.phone),
                  label: Text(AppLocalizations.of(context)!.call),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
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
