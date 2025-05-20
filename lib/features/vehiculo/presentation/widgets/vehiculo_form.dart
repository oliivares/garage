import 'package:flutter/material.dart';
import 'package:app_garagex/services/vehiculo_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehiculoForm extends StatefulWidget {
  final VoidCallback onSuccess;
  final int usuarioId;

  const VehiculoForm({
    required this.usuarioId,
    required this.onSuccess,
    super.key,
  });

  @override
  State<VehiculoForm> createState() => _VehiculoFormState();
}

class _VehiculoFormState extends State<VehiculoForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _matriculaController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _motorController = TextEditingController();

  int? _selectedAnyo;
  int? _selectedPotencia;

  String? _errorMessage;
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
  void dispose() {
    _matriculaController.dispose();
    _marcaController.dispose();
    _motorController.dispose();
    super.dispose();
  }

  Future<void> _guardarVehiculo() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _errorMessage = null; // Limpiar error anterior
      });

      final vehiculoJson = {
        "matricula": _matriculaController.text.trim(),
        "marca": _marcaController.text.trim(),
        "potencia": _selectedPotencia ?? 0,
        "motor": _motorController.text.trim(),
        "anyo": _selectedAnyo ?? 0,
        "usuario": {"id": widget.usuarioId},
      };

      print("📤 Enviando vehículo: $vehiculoJson");

      final response = await VehiculoService.agregarVehiculo(vehiculoJson);

      if (response["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.vehicleAddedSuccessfully,
            ),
          ),
        );
        widget.onSuccess(); // callback para refrescar
      } else {
        setState(() {
          _errorMessage =
              response["message"] ?? "Error desconocido al agregar el vehículo";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          TextFormField(
            controller: _matriculaController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.licensePlate,
            ),
            validator:
                (value) =>
                    value!.isEmpty
                        ? AppLocalizations.of(context)!.enterTheTuition
                        : null,
          ),
          TextFormField(
            controller: _marcaController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.brand,
            ),
            validator:
                (value) =>
                    value!.isEmpty
                        ? AppLocalizations.of(context)!.enterTheBrand
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
                  // Opcional: para mostrar "1k CV" en lugar de "1000 CV"
                  if (cv == 1000) label = "1,000 CV";
                  if (cv == 1200) label = "1,200 CV";
                  if (cv == 1400) label = "1,400 CV";
                  if (cv == 1600) label = "1,600 CV";
                  if (cv == 1800) label = "1,800 CV";
                  if (cv == 2000) label = "2,000 CV";
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
          TextFormField(
            controller: _motorController,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.motor,
            ),
            validator:
                (value) =>
                    value!.isEmpty
                        ? AppLocalizations.of(context)!.enterTheMotor
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _guardarVehiculo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.deepOrange,
              side: const BorderSide(color: Colors.deepOrange, width: 3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(AppLocalizations.of(context)!.saveVehicle),
          ),
        ],
      ),
    );
  }
}
