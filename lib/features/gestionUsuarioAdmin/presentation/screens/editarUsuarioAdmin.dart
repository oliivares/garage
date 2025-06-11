import 'package:app_garagex/services/auth_service.dart';
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
  }

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
            ),
            TextField(
              controller: nombreUsuarioCtrl,
              decoration: const InputDecoration(labelText: "Nombre de usuario"),
            ),
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: telefonoCtrl,
              decoration: const InputDecoration(labelText: "Teléfono"),
            ),
            DropdownButton<String>(
              value: rolSeleccionado,
              items: const [
                DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
                DropdownMenuItem(
                  value: "JEFE_TALLER",
                  child: Text("JEFE_TALLER"),
                ),
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
            final res = await AuthService.actualizarUsuario(
              nombre: nombreCtrl.text,
              nombreUsuario: nombreUsuarioCtrl.text,
              email: emailCtrl.text,
              telefono: telefonoCtrl.text,
              rol: rolSeleccionado,
            );
            if (res["success"]) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Usuario actualizado")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(res["message"] ?? "Error")),
              );
            }
          },
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}
