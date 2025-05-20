import 'dart:convert';

import 'package:app_garagex/features/login/presentation/screens/login_screen.dart';
import 'package:app_garagex/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosPersonalesScreen extends StatefulWidget {
  const DatosPersonalesScreen({super.key});

  @override
  State<DatosPersonalesScreen> createState() => _DatosPersonalesScreenState();
}

class _DatosPersonalesScreenState extends State<DatosPersonalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController usuarioController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final result = await AuthService.getUsuarioActual();

    if (result["success"] == true) {
      final usuario = result["usuario"];

      setState(() {
        nombreController.text = usuario["nombre"] ?? '';
        usuarioController.text = usuario["nombreUsuario"] ?? '';
        emailController.text = usuario["email"] ?? '';
        telefonoController.text = (usuario["telefono"] ?? '').toString();
      });
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result["message"] ?? "Error al cargar datos")),
        );
      }
    }
  }

  Future<void> _actualizarDatos() async {
    if (_formKey.currentState!.validate()) {
      final result = await AuthService.actualizarUsuario(
        nombre: nombreController.text.trim(),
        nombreUsuario: usuarioController.text.trim(),
        email: emailController.text.trim(),
        telefono: telefonoController.text.trim(),
      );

      if (result["success"]) {
        final usuario = result["usuario"];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("usuario", jsonEncode(usuario));

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos actualizados correctamente')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result["message"] ?? "Error al actualizar")),
          );
        }
      }
    }
  }

  Future<void> _cambiarContrasena() async {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Verificar contraseña"),
            content: TextField(
              controller: currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Contraseña actual"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  if (currentPasswordController.text == "1234") {
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña incorrecta')),
                    );
                  }
                },
                child: const Text("Verificar"),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    await showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Nueva contraseña"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nueva contraseña",
                  ),
                ),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirmar contraseña",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () async {
                  if (newPasswordController.text !=
                      confirmPasswordController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Las contraseñas no coinciden'),
                      ),
                    );
                  } else {
                    // Aquí actualizarías la contraseña en el backend
                    Navigator.pop(context);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.clear(); // Cierra sesión

                    if (context.mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  }
                },
                child: const Text("Actualizar contraseña"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datos Personales"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField("Nombre completo", Icons.person, nombreController),
              _buildField(
                "Nombre de usuario",
                Icons.account_circle,
                usuarioController,
              ),
              _buildField(
                "Email",
                Icons.email,
                emailController,
                TextInputType.emailAddress,
              ),
              _buildField(
                "Teléfono",
                Icons.phone,
                telefonoController,
                TextInputType.phone,
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: _cambiarContrasena,
                child: const Text(
                  "¿Cambiar contraseña?",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _actualizarDatos,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("Actualizar Datos"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    IconData icon,
    TextEditingController controller, [
    TextInputType keyboardType = TextInputType.text,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator:
            (value) =>
                value == null || value.isEmpty ? "Campo obligatorio" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
