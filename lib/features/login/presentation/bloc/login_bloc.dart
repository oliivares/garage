import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_garagex/services/auth_service.dart';

class LoginBloc {
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    final result = await AuthService.loginUser(
      userName: username,
      password: password,
    );

    if (result["success"]) {
      final token = result["token"];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      final userResult = await AuthService.getUsuarioActual();

      if (userResult["success"]) {
        final usuario = userResult["usuario"];
        await prefs.setString("usuario", jsonEncode(usuario));
        await prefs.setInt("usuarioId", usuario["id"]);
      }
    }

    return result;
  }
}
