import 'package:app_garagex/services/register_service.dart';

class RegisterBloc {
  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String username,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if ([
      name,
      username,
      email,
      phone,
      password,
      confirmPassword,
    ].any((field) => field.isEmpty)) {
      return {
        'success': false,
        'message': 'Rellene los campos obligatorios (*)',
      };
    }

    if (!esCorreoValido(email)) {
      return {
        'success': false,
        'message':
            'El correo debe contener un @ y terminar en .com, .es o .org',
      };
    }

    if (password != confirmPassword) {
      return {'success': false, 'message': 'Las contraseñas no coinciden'};
    }

    final errores = validarContrasenaSegura(password);
    if (errores.isNotEmpty) {
      return {'success': false, 'message': errores.join('\n')};
    }

    return await InsertarUsuarioService.insertarUsuario(
      nombre: name,
      usuario: username,
      contrasenya: password,
      correo: email,
      telefono: phone.isEmpty ? null : phone,
    );
  }
}

bool esCorreoValido(String correo) {
  final RegExp regex = RegExp(
    r'^[\w\.-]+@[\w\.-]+\.(com|es|org)$',
    caseSensitive: false,
  );
  return regex.hasMatch(correo.trim());
}

List<String> validarContrasenaSegura(String contrasena) {
  List<String> errores = [];

  if (contrasena.length < 7) {
    errores.add("* Debe tener al menos 7 caracteres");
  }
  if (!RegExp(r'[A-Z]').hasMatch(contrasena)) {
    errores.add("* Debe contener al menos una letra mayúscula");
  }
  if (!RegExp(r'[a-z]').hasMatch(contrasena)) {
    errores.add("* Debe contener al menos una letra minúscula");
  }
  if (!RegExp(r'[0-9]').hasMatch(contrasena)) {
    errores.add("* Debe contener al menos un número");
  }
  if (!RegExp(r'[!@#\$&*~^%()_\-+=<>?/.,:;{}\[\]|]').hasMatch(contrasena)) {
    errores.add("* Debe contener al menos un símbolo");
  }

  return errores;
}
