import 'package:app_garagex/features/datos_personales/presentation/bloc/datos_personales_bloc.dart';
import 'package:app_garagex/features/login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatosPersonalesScreen extends StatefulWidget {
  const DatosPersonalesScreen({super.key});

  @override
  State<DatosPersonalesScreen> createState() => _DatosPersonalesScreenState();
}

class _DatosPersonalesScreenState extends State<DatosPersonalesScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = DatosPersonalesController();

  @override
  void initState() {
    super.initState();
    controller.cargarDatosUsuario((msg) => _mostrarSnack(msg));
  }

  void _mostrarSnack(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  Future<void> _cambiarContrasenaDialog() async {
    final actualController = TextEditingController();
    final nuevaController = TextEditingController();
    final confirmarController = TextEditingController();

    final resultado = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Cambiar contraseña"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _passwordField("Contraseña actual", actualController),
                _passwordField("Nueva contraseña", nuevaController),
                _passwordField("Confirmar contraseña", confirmarController),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Actualizar"),
              ),
            ],
          ),
    );

    if (resultado == true) {
      final error = await controller.cambiarContrasena(
        actual: actualController.text,
        nueva: nuevaController.text,
        confirmacion: confirmarController.text,
      );

      if (error != null) {
        _mostrarSnack(error);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      }
    }
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
              _buildField(
                "Nombre completo",
                Icons.person,
                controller.nombreController,
              ),
              _buildField(
                "Nombre de usuario",
                Icons.account_circle,
                controller.usuarioController,
              ),
              _buildField(
                "Email",
                Icons.email,
                controller.emailController,
                TextInputType.emailAddress,
              ),
              _buildField(
                "Teléfono",
                Icons.phone,
                controller.telefonoController,
                TextInputType.phone,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _cambiarContrasenaDialog,
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final success = await controller.actualizarDatos(
                      (msg) => _mostrarSnack(msg),
                    );
                    if (success)
                      _mostrarSnack("Datos actualizados correctamente");
                  }
                },
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

  Widget _passwordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(labelText: label),
    );
  }
}
