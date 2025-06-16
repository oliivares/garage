import 'package:app_garagex/features/location/presentation/bloc/servicio_citas.dart';
import 'package:app_garagex/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? _usuario;
  List<Map<String, dynamic>> _citas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarUsuario();
  }

  Future<void> _cargarUsuario() async {
    final response = await AuthService.getUsuarioActual();
    if (response['success']) {
      setState(() {
        _usuario = response['usuario'];
      });

      final citas = await CitaService.obtenerCitasPorUsuarioActual();
      print("CITAS CARGADAS:");
      print(citas);

      setState(() {
        _citas = citas;
        _cargando = false;
      });
    } else {
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error desconocido')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GarageX"),
        backgroundColor: Colors.deepOrangeAccent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppLocalizations.of(context)!.notifications),
                ),
              );
            },
          ),
        ],
      ),
      body:
          _cargando
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Usuario y rol
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.deepOrangeAccent),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.deepOrangeAccent,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.user}: ${_usuario?['nombre'] ?? '---'}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text("Rol: ${_usuario?['rol'] ?? '---'}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Título de citas
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Tus citas",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Lista de citas
                      ..._citas.map(
                        (cita) => Card(
                          elevation: 3,
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: const Icon(
                              Icons.calendar_today,
                              color: Colors.deepOrangeAccent,
                            ),
                            title: Text(
                              cita['descripcion'] ?? 'Sin descripción',
                            ),
                            subtitle: Text(
                              "Fecha: ${cita['fechaHoraCita'] ?? ''}\nEstado: ${cita['estado'] ?? ''}",
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
