import 'package:app_garagex/features/vehiculo/presentation/bloc/vehiculo_mod_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

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

  int? _selectedPotencia;
  int? _selectedAnyo;

  final List<int> potenciaOptions = [
    0,
    5,
    10,
    15,
    20,
    25,
    30,
    35,
    40,
    45,
    50,
    75,
    100,
    150,
    200,
    250,
    300,
    350,
    400,
    450,
    500,
    600,
    700,
    800,
    900,
    1000,
    1200,
    1400,
    1600,
    1800,
    2000,
  ];

  @override
  void initState() {
    super.initState();
    bloc = EditarVehiculoBloc();
    bloc.inicializarCamposVehiculo(widget.vehiculo);

    _selectedPotencia = int.tryParse(bloc.potenciaController.text);
    _selectedAnyo = int.tryParse(bloc.anyoController.text);
  }

  void _guardarCambios() async {
    if (!_formKey.currentState!.validate()) return;

    bloc.potenciaController.text = _selectedPotencia?.toString() ?? '0';
    bloc.anyoController.text = _selectedAnyo?.toString() ?? '0';

    final result = await bloc.editarVehiculo(widget.vehiculo);

    if (result["success"]) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.vehicleUpdated),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
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
                DropdownButtonFormField<int>(
                  value: _selectedPotencia,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.power,
                  ),
                  items:
                      potenciaOptions.map((cv) {
                        String label =
                            cv >= 1000
                                ? '${(cv / 1000).toStringAsFixed(cv % 1000 == 0 ? 0 : 1)}k CV'
                                : '$cv CV';
                        if ([1000, 1200, 1400, 1600, 1800, 2000].contains(cv)) {
                          label = '${cv ~/ 1000},${(cv % 1000 ~/ 100)}00 CV';
                        }
                        return DropdownMenuItem(value: cv, child: Text(label));
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPotencia = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null
                              ? AppLocalizations.of(context)!.selectThePower
                              : null,
                ),
                DropdownButtonFormField<int>(
                  value: _selectedAnyo,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.year,
                  ),
                  items: List.generate(DateTime.now().year - 1998, (index) {
                    int year = 1999 + index;
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }),
                  onChanged: (value) {
                    setState(() {
                      _selectedAnyo = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null
                              ? AppLocalizations.of(context)!.selectAnyo
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
