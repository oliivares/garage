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

    if (!email.toLowerCase().endsWith('@gmail.com')) {
      return {
        'success': false,
        'message': 'El correo debe ser un @gmail.com válido',
      };
    }

    if (password != confirmPassword) {
      return {'success': false, 'message': 'Las contraseñas no coinciden'};
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
