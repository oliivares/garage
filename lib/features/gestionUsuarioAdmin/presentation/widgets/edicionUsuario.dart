import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/bloc/editarUsuario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditarUsuarioView extends StatelessWidget {
  const EditarUsuarioView();

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<EditarUsuarioController>(context);
    final opcionesRol = controller.getOpcionesRol();

    return AlertDialog(
      title: const Text("Editar usuario"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller.nombreCtrl,
              decoration: const InputDecoration(labelText: "Nombre"),
              enabled: false,
            ),
            TextField(
              controller: controller.nombreUsuarioCtrl,
              decoration: const InputDecoration(labelText: "Nombre de usuario"),
              enabled: false,
            ),
            TextField(
              controller: controller.emailCtrl,
              decoration: const InputDecoration(labelText: "Email"),
              enabled: false,
            ),
            TextField(
              controller: controller.telefonoCtrl,
              decoration: const InputDecoration(labelText: "Teléfono"),
              enabled: false,
            ),
            const SizedBox(height: 10),
            if (opcionesRol.isNotEmpty)
              DropdownButton<String>(
                value: controller.rolSeleccionado,
                items: opcionesRol,
                onChanged: (value) {
                  if (value != null) {
                    controller.actualizarRol(value);
                  }
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
              if (!controller.cambioRol()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("No hay cambios en el rol")),
                );
                return;
              }

              final resultado = await controller.guardarCambios();

              if (context.mounted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(resultado["message"])));
                if (resultado["success"]) Navigator.pop(context);
              }
            },
            child: const Text("Guardar cambios"),
          ),
      ],
    );
  }
}
