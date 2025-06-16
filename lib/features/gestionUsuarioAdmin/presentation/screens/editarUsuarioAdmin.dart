import 'package:app_garagex/services/usuarioSearh_service.dart';
import 'package:flutter/material.dart';

class EditarUsuarioDialog extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final String
  rolActualUsuario; // Nuevo parámetro para saber rol de quien edita

  const EditarUsuarioDialog({
    super.key,
    required this.usuario,
    required this.rolActualUsuario,
  });

  @override
  State<EditarUsuarioDialog> createState() => _EditarUsuarioDialogState();
}

class _EditarUsuarioDialogState extends State<EditarUsuarioDialog> {
  late TextEditingController nombreCtrl;
  late TextEditingController nombreUsuarioCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController telefonoCtrl;
  late String rolSeleccionado;

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

  List<DropdownMenuItem<String>> _getOpcionesRol() {
    if (widget.rolActualUsuario == "ADMINISTRADOR") {
      return const [
        DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
        DropdownMenuItem(value: "JEFE_TALLER", child: Text("JEFE_TALLER")),
      ];
    } else if (widget.rolActualUsuario == "JEFE_TALLER") {
      return const [
        DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
        DropdownMenuItem(value: "MECANICO", child: Text("MECANICO")),
      ];
    } else {
      // Si otro rol, no permite cambiar rol
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final opcionesRol = _getOpcionesRol();

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
            if (opcionesRol.isNotEmpty)
              DropdownButton<String>(
                value: rolSeleccionado,
                items: opcionesRol,
                onChanged: (value) {
                  setState(() {
                    rolSeleccionado = value!;
                  });
                },
              )
            else
              const Text("No tienes permiso para cambiar el rol."),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        if (opcionesRol.isNotEmpty)
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
