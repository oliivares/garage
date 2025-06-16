import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:app_garagex/features/gestionJefeTaller/presentation/screens/crearTaller.dart';
import 'package:app_garagex/features/gestionJefeTaller/presentation/screens/editarTaller.dart';
import 'package:app_garagex/features/location/data/models/taller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MisTalleresScreen extends StatefulWidget {
  const MisTalleresScreen({super.key});

  @override
  State<MisTalleresScreen> createState() => _MisTalleresScreenState();
}

class _MisTalleresScreenState extends State<MisTalleresScreen> {
  List<Taller> talleres = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchTalleres();
  }

  Future<void> _fetchTalleres() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? '';
      final url = StaticData.baseUrl;

      final response = await http.get(
        Uri.parse('$url/taller/propios'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> body = jsonDecode(response.body);
        setState(() {
          talleres = body.map((item) => Taller.fromJson(item)).toList();
          loading = false;
        });
      } else {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los talleres')),
        );
      }
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Talleres'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CrearTallerScreen()),
              );
              if (resultado == true) _fetchTalleres();
            },
          ),
        ],
      ),
      body:
          loading
              ? const Center(child: CircularProgressIndicator())
              : talleres.isEmpty
              ? const Center(child: Text('No hay talleres disponibles.'))
              : ListView.builder(
                itemCount: talleres.length,
                itemBuilder: (_, index) {
                  final taller = talleres[index];
                  return ListTile(
                    title: Text(taller.nombre),
                    subtitle: Text('${taller.direccion} - ${taller.email}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(taller.telefono.toString()),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () async {
                            final resultado = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EditarTallerScreen(taller: taller),
                              ),
                            );
                            if (resultado == true) _fetchTalleres();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
