import 'package:app_garagex/features/vehiculo/presentation/bloc/vehiculo_bloc.dart';
import 'package:app_garagex/features/vehiculo/presentation/widgets/vehiculo_form.dart';
import 'package:app_garagex/features/vehiculo/presentation/widgets/vehiculo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VehiculosScreen extends StatefulWidget {
  const VehiculosScreen({super.key});

  @override
  State<VehiculosScreen> createState() => _VehiculosScreenState();
}

class _VehiculosScreenState extends State<VehiculosScreen> {
  late VehiculosBloc controller;
  int? usuarioId;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    controller = VehiculosBloc(
      onRefresh: () {
        setState(() {});
      },
    );
    _initUsuario();
  }

  Future<void> _initUsuario() async {
    usuarioId = await controller.obtenerUsuarioId();
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.vehiclesTitle),
        backgroundColor: Colors.deepOrangeAccent,
        automaticallyImplyLeading: false,
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<Map<String, dynamic>>>(
                future: controller.cargarVehiculos(usuarioId!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.vehiclesLoadError,
                      ),
                    );
                  }

                  final vehiculos = snapshot.data ?? [];

                  if (vehiculos.isEmpty) {
                    return Center(
                      child: Text(
                        AppLocalizations.of(context)!.vehiclesEmpty,
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: vehiculos.length,
                    itemBuilder: (context, index) {
                      return VehiculoItem(
                        vehiculo: vehiculos[index],
                        controller: controller,
                      );
                    },
                  );
                },
              ),
      floatingActionButton:
          _loading
              ? null
              : FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (_) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: VehiculoForm(
                              usuarioId: usuarioId!,
                              onSuccess: () {
                                Navigator.pop(context);
                                setState(
                                  () {},
                                ); // Refrescar lista tras añadir vehículo
                              },
                            ),
                          ),
                        ),
                  );
                },
                icon: const Icon(
                  Icons.directions_car,
                  color: Colors.deepOrange,
                ),
                label: Text(
                  AppLocalizations.of(context)!.vehiclesAdd,
                  style: TextStyle(color: Colors.deepOrange),
                ),
                backgroundColor: const Color.fromARGB(160, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.deepOrange, width: 3),
                ),
              ),
    );
  }
}
