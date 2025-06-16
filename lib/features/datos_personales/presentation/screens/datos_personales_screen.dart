import 'package:app_garagex/features/datos_personales/presentation/bloc/datos_personales_bloc.dart';
import 'package:app_garagex/features/datos_personales/presentation/widgets/cambio_contrasena_form.dart';
import 'package:app_garagex/features/login/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

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
    await showDialog(
      context: context,
      builder:
          (_) => CambiarContrasenaDialog(
            validarContrasena: controller.validarContrasenaSegura,
            onCambiarContrasena: ({
              required String actual,
              required String nueva,
              required String confirmacion,
            }) async {
              try {
                final error = await controller.cambiarContrasena(
                  actual: actual,
                  nueva: nueva,
                  confirmacion: confirmacion,
                );

                if (error == null) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();

                  if (Navigator.canPop(context)) {
                    Navigator.pop(context); // cerrar diálogo
                  }

                  Future.microtask(() {
                    if (mounted) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (route) => false,
                      );
                    }
                  });
                }

                return error;
              } catch (e, st) {
                debugPrint("🔥 Error en onCambiarContrasena: $e\n$st");
                return "Ocurrió un error inesperado";
              }
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.personalData),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(
                AppLocalizations.of(context)!.fullName,
                Icons.person,
                controller.nombreController,
              ),
              _buildField(
                AppLocalizations.of(context)!.userName,
                Icons.account_circle,
                controller.usuarioController,
              ),
              _buildField(
                AppLocalizations.of(context)!.email,
                Icons.email,
                controller.emailController,
                TextInputType.emailAddress,
              ),
              _buildField(
                AppLocalizations.of(context)!.phone,
                Icons.phone,
                controller.telefonoController,
                TextInputType.number,
                [FilteringTextInputFormatter.digitsOnly],
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
                    if (success) {
                      _mostrarSnack("Datos actualizados correctamente");
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Actualizar Datos",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
    List<TextInputFormatter>? inputFormatters,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
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
