import 'dart:convert';
import 'package:app_garagex/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosPersonalesController {
  final nombreController = TextEditingController();
  final usuarioController = TextEditingController();
  final emailController = TextEditingController();
  final telefonoController = TextEditingController();

  bool validarEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.(com|es|org)$');
    return regex.hasMatch(email.trim());
  }

  Future<void> cargarDatosUsuario(Function(String) mostrarMensaje) async {
    final result = await AuthService.getUsuarioActual();

    if (result["success"] == true) {
      final usuario = result["usuario"];
      nombreController.text = usuario["nombre"] ?? '';
      usuarioController.text = usuario["nombreUsuario"] ?? '';
      emailController.text = usuario["email"] ?? '';
      telefonoController.text = (usuario["telefono"] ?? '').toString();
    } else {
      mostrarMensaje(result["message"] ?? "Error al cargar datos");
    }
  }

  Future<bool> actualizarDatos(Function(String) mostrarMensaje) async {
    if (!validarEmail(emailController.text)) {
      mostrarMensaje(
        "El correo debe contener un '@' y terminar en .com, .es o .org",
      );
      return false;
    }

    final usuarioActualResult = await AuthService.getUsuarioActual();
    if (usuarioActualResult["success"] != true) {
      mostrarMensaje(
        "No se pudo obtener el usuario actual para obtener el rol",
      );
      return false;
    }

    final usuarioActual = usuarioActualResult["usuario"];
    final rolActual = usuarioActual["rol"] ?? "CLIENTE";

    final result = await AuthService.actualizarUsuario(
      nombre: nombreController.text.trim(),
      nombreUsuario: usuarioController.text.trim(),
      email: emailController.text.trim(),
      telefono: telefonoController.text.trim(),
      rol: rolActual,
    );

    if (result["success"]) {
      final usuario = result["usuario"];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("usuario", jsonEncode(usuario));
      return true;
    } else {
      mostrarMensaje(result["message"] ?? "Error al actualizar datos");
      return false;
    }
  }

  Future<String?> cambiarContrasena({
    required String actual,
    required String nueva,
    required String confirmacion,
  }) async {
    if (nueva != confirmacion) {
      return "Las contraseñas no coinciden";
    }

    final response = await AuthService.cambiarContrasena(actual, nueva);
    return response["success"] ? null : response["message"];
  }

  List<String> validarContrasenaSegura(String contrasena) {
    List<String> errores = [];

    if (contrasena.length < 7) {
      errores.add("Debe tener al menos 7 caracteres");
    }
    if (!RegExp(r'[A-Z]').hasMatch(contrasena)) {
      errores.add("Debe contener al menos una letra mayúscula");
    }
    if (!RegExp(r'[a-z]').hasMatch(contrasena)) {
      errores.add("Debe contener al menos una letra minúscula");
    }
    if (!RegExp(r'[0-9]').hasMatch(contrasena)) {
      errores.add("Debe contener al menos un número");
    }
    if (!RegExp(r'[!@#\$&*~^%()_\-+=<>?/.,:;{}\[\]|]').hasMatch(contrasena)) {
      errores.add("Debe contener al menos un símbolo");
    }

    return errores;
  }
}
