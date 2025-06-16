import 'package:flutter/material.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

Widget usuarioInfo(Map<String, dynamic>? usuario, BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.orange.shade50,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.deepOrangeAccent),
    ),
    child: Row(
      children: [
        const Icon(Icons.person, color: Colors.deepOrangeAccent),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${AppLocalizations.of(context)!.user}: ${usuario?['nombre'] ?? '---'}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("Rol: ${usuario?['rol'] ?? '---'}"),
          ],
        ),
      ],
    ),
  );
}

Widget citasList(List<Map<String, dynamic>> citas) {
  return Column(
    children:
        citas
            .map(
              (cita) => Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: const Icon(
                    Icons.calendar_today,
                    color: Colors.deepOrangeAccent,
                  ),
                  title: Text(cita['descripcion'] ?? 'Sin descripción'),
                  subtitle: Text(
                    "Fecha: ${cita['fechaHoraCita'] ?? ''}\nEstado: ${cita['estado'] ?? ''}",
                  ),
                  isThreeLine: true,
                ),
              ),
            )
            .toList(),
  );
}
