import 'package:app_garagex/features/data/static_data.dart';
import 'package:app_garagex/services/taller_service.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';

class EditarTallerScreen extends StatefulWidget {
  final Taller taller;

  const EditarTallerScreen({super.key, required this.taller});

  @override
  State<EditarTallerScreen> createState() => _EditarTallerScreenState();
}

class _EditarTallerScreenState extends State<EditarTallerScreen> {
  late TextEditingController nombreCtrl;
  late TextEditingController direccionCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefonoCtrl;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.taller.nombre);
    direccionCtrl = TextEditingController(text: widget.taller.direccion);
    emailCtrl = TextEditingController(text: widget.taller.email);
    telefonoCtrl = TextEditingController(
      text: widget.taller.telefono.toString(),
    );
  }

  Future<void> _guardarCambios() async {
    final telefonoParsed = int.tryParse(telefonoCtrl.text);
    if (telefonoParsed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Teléfono inválido. Debe ser numérico.")),
      );
      return;
    }

    final actualizado = Taller(
      id: widget.taller.id,
      nombre: nombreCtrl.text,
      direccion: direccionCtrl.text,
      email: emailCtrl.text,
      telefono: telefonoParsed,
      latitud: widget.taller.latitud,
      longitud: widget.taller.longitud,
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
