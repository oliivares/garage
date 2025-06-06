import 'package:flutter/material.dart';

class CambiarContrasenaDialog extends StatefulWidget {
  final Future<String?> Function({
    required String actual,
    required String nueva,
    required String confirmacion,
  })
  onCambiarContrasena;

  final List<String> Function(String contrasena) validarContrasena;

  const CambiarContrasenaDialog({
    super.key,
    required this.onCambiarContrasena,
    required this.validarContrasena,
  });

  @override
  State<CambiarContrasenaDialog> createState() =>
      _CambiarContrasenaDialogState();
}

class _CambiarContrasenaDialogState extends State<CambiarContrasenaDialog> {
  final actualController = TextEditingController();
  final nuevaController = TextEditingController();
  final confirmarController = TextEditingController();

  bool _verActual = false;
  bool _verNueva = false;
  bool _verConfirmar = false;

  String? errorMensaje;

  @override
  void dispose() {
    actualController.dispose();
    nuevaController.dispose();
    confirmarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.deepOrange, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Cambiar contraseña",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _passwordField(
                "Contraseña actual",
                actualController,
                _verActual,
                () {
                  if (!mounted) return;
                  setState(() => _verActual = !_verActual);
                },
              ),
              const SizedBox(height: 12),
              _passwordField(
                "Nueva contraseña",
                nuevaController,
                _verNueva,
                () {
                  if (!mounted) return;
                  setState(() => _verNueva = !_verNueva);
                },
              ),
              const SizedBox(height: 12),
              _passwordField(
                "Confirmar contraseña",
                confirmarController,
                _verConfirmar,
                () {
                  if (!mounted) return;
                  setState(() => _verConfirmar = !_verConfirmar);
                },
              ),
              if (errorMensaje != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    errorMensaje!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.deepOrange,
                    ),
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final nueva = nuevaController.text;
                      final confirmacion = confirmarController.text;
                      final errores = widget.validarContrasena(nueva);

                      if (nueva != confirmacion) {
                        errores.add("Las contraseñas no coinciden");
                      }

                      if (errores.isNotEmpty) {
                        if (!mounted) return;
                        setState(() {
                          errorMensaje = errores.join('\n');
                        });
                        return;
                      }

                      final error = await widget.onCambiarContrasena(
                        actual: actualController.text,
                        nueva: nueva,
                        confirmacion: confirmacion,
                      );

                      if (error != null) {
                        if (!mounted) return;
                        setState(() {
                          errorMensaje = error;
                        });
                      } else {
                        if (!mounted) return;
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepOrange,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: const Text("Actualizar"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _passwordField(
    String label,
    TextEditingController controller,
    bool isVisible,
    VoidCallback toggleVisibility,
  ) {
    return TextField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }
}
