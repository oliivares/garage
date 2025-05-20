import 'package:app_garagex/features/vehiculo/presentation/bloc/vehiculo_mod_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vehicleUpdated),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(
        const Duration(seconds: 2),
      ); // Espera que se vea el mensaje
      widget.onSuccess();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result["message"] ?? AppLocalizations.of(context)!.errorEditing,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editVehicle),
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
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.licensePlate,
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? "Campo requerido"
                              : null,
                ),
                TextFormField(
                  controller: bloc.marcaController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.brand,
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.fieldRequired
                              : null,
                ),
                TextFormField(
                  controller: bloc.motorController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.motor,
                  ),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.fieldRequired
                              : null,
                ),
                TextFormField(
                  controller: bloc.potenciaController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.power,
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.fieldRequired
                              : null,
                ),
                TextFormField(
                  controller: bloc.anyoController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.year,
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.fieldRequired
                              : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrangeAccent,
                  ),
                  child: Text(AppLocalizations.of(context)!.confirmEdition),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
