import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/bloc/busquedaUsuario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/screens/editarUsuarioAdmin.dart';

class ListaSugerencias extends StatelessWidget {
  const ListaSugerencias({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BuscarUsuarioController>(context);

    if (controller.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: controller.sugerencias.length,
      itemBuilder: (context, index) {
        final sugerencia = controller.sugerencias[index];

        return ListTile(
          title: Text(sugerencia),
          onTap: () async {
            try {
              final usuarioCompleto = await controller.obtenerUsuarioCompleto(
                sugerencia,
              );

              if (context.mounted) {
                showDialog(
                  context: context,
                  builder:
                      (_) => EditarUsuarioDialog(
                        usuario: usuarioCompleto!,
                        rolActualUsuario: controller.rolActualUsuario,
                      ),
                );
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error al cargar el usuario: $e")),
                );
              }
            }
          },
        );
      },
    );
  }
}
