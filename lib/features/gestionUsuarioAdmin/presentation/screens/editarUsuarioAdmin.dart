import 'package:app_garagex/services/usuarioSearh_service.dart';
import 'package:flutter/material.dart';

class EditarUsuarioDialog extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const EditarUsuarioDialog({super.key, required this.usuario});

  @override
  State<EditarUsuarioDialog> createState() => _EditarUsuarioDialogState();
}

class _EditarUsuarioDialogState extends State<EditarUsuarioDialog> {
  late TextEditingController nombreCtrl;
  late TextEditingController nombreUsuarioCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefonoCtrl;
  String rolSeleccionado = "CLIENTE";

  late final UsuarioSearchService _searchService;

  @override
  void initState() {
    super.initState();
    nombreCtrl = TextEditingController(text: widget.usuario["nombre"]);
    nombreUsuarioCtrl = TextEditingController(
      text: widget.usuario["nombreUsuario"],
    );
    emailCtrl = TextEditingController(text: widget.usuario["email"]);
    telefonoCtrl = TextEditingController(
      text: widget.usuario["telefono"].toString(),
    );
    rolSeleccionado = widget.usuario["rol"] ?? "CLIENTE";

    _searchService = UsuarioSearchService(client: createIOClient());
  }

  bool _cambioRol() => widget.usuario['rol'] != rolSeleccionado;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Editar usuario"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
              enabled: false,
            ),
            TextField(
              controller: nombreUsuarioCtrl,
              decoration: const InputDecoration(labelText: "Nombre de usuario"),
              enabled: false,
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              enabled: false,
            ),
            TextField(
              controller: telefonoCtrl,
              decoration: const InputDecoration(labelText: "Teléfono"),
              enabled: false,
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: rolSeleccionado,
              items: const [
                DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
                DropdownMenuItem(
                  value: "JEFE_TALLER",
                  child: Text("JEFE_TALLER"),
                ),
                DropdownMenuItem(value: "MECANICO", child: Text("MECANICO")),
              ],
              onChanged: (value) {
                setState(() {
                  rolSeleccionado = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (!_cambioRol()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No hay cambios en el rol")),
              );
              return;
            }

            final resultado = await _searchService.cambiarRolUsuario(
              nombreUsuario: widget.usuario['nombreUsuario'],
              nuevoRol: rolSeleccionado,
            );

            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(resultado["message"])));

            if (resultado["success"]) Navigator.pop(context);
          },
          child: const Text("Guardar cambios"),
        ),
      ],
    );
  }
}
