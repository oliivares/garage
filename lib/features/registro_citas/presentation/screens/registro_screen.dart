import 'package:app_garagex/features/registro_citas/presentation/bloc/registro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CitaScreen extends StatelessWidget {
  const CitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final citaBloc = Provider.of<CitaBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Citas"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: FutureBuilder(
        future: citaBloc.cargarCitas(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return ListView.builder(
              itemCount: citaBloc.citas.length,
              itemBuilder: (context, index) {
                final cita = citaBloc.citas[index];
                return ListTile(
                  title: Text(cita['descripcion']),
                  subtitle: Text("Estado: ${cita['estado']}"),
                  onTap: () async {
                    await citaBloc.seleccionarCita(cita['id']);
                    if (citaBloc.citaSeleccionada != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CitaDetalleScreen(
                              cita: citaBloc.citaSeleccionada!),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class CitaDetalleScreen extends StatelessWidget {
  final Map<String, dynamic> cita;

  const CitaDetalleScreen({super.key, required this.cita});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detalle de la Cita"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Descripción: ${cita['descripcion']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Estado: ${cita['estado']}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text("Fecha: ${cita['fecha']}", style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
