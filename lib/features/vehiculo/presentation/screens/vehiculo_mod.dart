// editar_vehiculo_screen.dart

import 'package:app_garagex/features/vehiculo/presentation/bloc/vehiculo_mod_bloc.dart';
import 'package:flutter/material.dart';

class EditarVehiculoScreen extends StatefulWidget {
  final Map<String, dynamic> vehiculo;
  final VoidCallback onSuccess;

  const EditarVehiculoScreen({
    super.key,
    required this.vehiculo,
    required this.onSuccess,
  });

  @override
  State<EditarVehiculoScreen> createState() => _EditarVehiculoScreenState();
}

class _EditarVehiculoScreenState extends State<EditarVehiculoScreen> {
  final _formKey = GlobalKey<FormState>();
  late EditarVehiculoBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = EditarVehiculoBloc();
    bloc.inicializarCamposVehiculo(widget.vehiculo);
  }

  void _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    final result = await bloc.editarVehiculo(widget.vehiculo);

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Vehículo actualizado correctamente"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Espera que se vea el mensaje
      widget.onSuccess();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Error al editar")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Vehículo"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: bloc.matriculaController,
                  decoration: const InputDecoration(labelText: "Matrícula"),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                TextFormField(
                  controller: bloc.marcaController,
                  decoration: const InputDecoration(labelText: "Marca"),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                TextFormField(
                  controller: bloc.motorController,
                  decoration: const InputDecoration(labelText: "Motor"),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                TextFormField(
                  controller: bloc.potenciaController,
                  decoration: const InputDecoration(labelText: "Potencia (CV)"),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                TextFormField(
                  controller: bloc.anyoController,
                  decoration: const InputDecoration(labelText: "Año"),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: const Text("Confirmar Edición"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
