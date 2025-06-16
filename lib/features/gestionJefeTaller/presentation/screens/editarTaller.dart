import 'package:flutter/material.dart';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:app_garagex/services/taller_service.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';

class EditarTallerScreen extends StatefulWidget {
  final Taller taller;

  const EditarTallerScreen({super.key, required this.taller});

  @override
  State<EditarTallerScreen> createState() => EditarTallerScreenState();
}

class EditarTallerScreenState extends State<EditarTallerScreen> {
  late TextEditingController nombreCtrl;
  late TextEditingController direccionCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefonoCtrl;
  late TextEditingController latitudCtrl;
  late TextEditingController longitudCtrl;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.taller.nombre);
    direccionCtrl = TextEditingController(text: widget.taller.direccion);
    emailCtrl = TextEditingController(text: widget.taller.email);
    telefonoCtrl = TextEditingController(
      text: widget.taller.telefono.toString(),
    );
    latitudCtrl = TextEditingController(text: widget.taller.latitud.toString());
    longitudCtrl = TextEditingController(
      text: widget.taller.longitud.toString(),
    );
  }

  Future<void> _guardarCambios() async {
    final telefonoParsed = int.tryParse(telefonoCtrl.text);
    final latitudParsed = double.tryParse(latitudCtrl.text);
    final longitudParsed = double.tryParse(longitudCtrl.text);

    if (telefonoParsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teléfono inválido. Debe ser numérico.")),
      );
      return;
    }

    if (latitudParsed == null || longitudParsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Latitud o longitud inválidas.")),
      );
      return;
    }

    final actualizado = Taller(
      id: widget.taller.id,
      nombre: nombreCtrl.text,
      direccion: direccionCtrl.text,
      email: emailCtrl.text,
      telefono: telefonoParsed,
      latitud: latitudParsed,
      longitud: longitudParsed,
    );

    try {
      final service = TalleresService(baseUrl: StaticData.baseUrl);
      final success = await service.actualizarTaller(actualizado);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Taller actualizado correctamente")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al actualizar el taller: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Taller')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: direccionCtrl,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: telefonoCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: latitudCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Latitud'),
            ),
            TextField(
              controller: longitudCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(labelText: 'Longitud'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _guardarCambios,
              child: const Text('Guardar cambios'),
            ),
          ],
        ),
      ),
    );
  }
}
