import 'package:flutter/material.dart';
import 'package:app_garagex/services/usuarioSearh_service.dart';

class EditarUsuarioController extends ChangeNotifier {
  final Map<String, dynamic> usuario;
  final String rolActualUsuario;

  late final TextEditingController nombreCtrl;
  late final TextEditingController nombreUsuarioCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController telefonoCtrl;
  late String rolSeleccionado;

  final UsuarioSearchService searchService = UsuarioSearchService(
    client: createIOClient(),
  );

  EditarUsuarioController({
    required this.usuario,
    required this.rolActualUsuario,
  }) {
    nombreCtrl = TextEditingController(text: usuario["nombre"]);
    nombreUsuarioCtrl = TextEditingController(text: usuario["nombreUsuario"]);
    emailCtrl = TextEditingController(text: usuario["email"]);
    telefonoCtrl = TextEditingController(text: usuario["telefono"].toString());
    rolSeleccionado = usuario["rol"] ?? "CLIENTE";
  }

  bool cambioRol() => usuario['rol'] != rolSeleccionado;

  List<DropdownMenuItem<String>> getOpcionesRol() {
    if (rolActualUsuario == "ADMINISTRADOR") {
      return const [
        DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
        DropdownMenuItem(value: "JEFE_TALLER", child: Text("JEFE_TALLER")),
      ];
    } else if (rolActualUsuario == "JEFE_TALLER") {
      return const [
        DropdownMenuItem(value: "CLIENTE", child: Text("CLIENTE")),
        DropdownMenuItem(value: "MECANICO", child: Text("MECANICO")),
      ];
    } else {
      return [];
    }
  }

  void actualizarRol(String nuevoRol) {
    rolSeleccionado = nuevoRol;
    notifyListeners();
  }

  Future<Map<String, dynamic>> guardarCambios() async {
    return await searchService.cambiarRolUsuario(
      nombreUsuario: usuario['nombreUsuario'],
      nuevoRol: rolSeleccionado,
    );
  }
}
