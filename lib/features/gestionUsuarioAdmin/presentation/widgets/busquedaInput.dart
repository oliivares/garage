import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/bloc/busquedaUsuario_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusquedaInput extends StatelessWidget {
  const BusquedaInput({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<BuscarUsuarioController>(context);
    return TextField(
      controller: controller.searchController,
      decoration: const InputDecoration(labelText: "Nombre de usuario"),
      onChanged: controller.onChanged,
    );
  }
}
