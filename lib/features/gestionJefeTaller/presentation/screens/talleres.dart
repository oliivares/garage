import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:app_garagex/features/gestionJefeTaller/presentation/screens/crearTaller.dart';
import 'package:app_garagex/features/gestionJefeTaller/presentation/screens/editarTaller.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/taller.dart';

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
        if (!mounted) return;
        setState(() {
          talleres = body.map((item) => Taller.fromJson(item)).toList();
          loading = false;
        });
      } else {
        if (!mounted) return;
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al cargar los talleres')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _eliminarTaller(int idTaller) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirmar eliminación"),
            content: const Text("¿Estás seguro de eliminar este taller?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Eliminar"),
              ),
            ],
          ),
    );

    if (confirmacion == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString("token") ?? '';
        final url = StaticData.baseUrl;

        final response = await http.delete(
          Uri.parse('$url/taller/$idTaller'),
          headers: {'Authorization': 'Bearer $token'},
        );

        if (!mounted) return;

        if (response.statusCode == 200) {
          setState(() {
            talleres.removeWhere((t) => t.id == idTaller);
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Taller eliminado")));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error al eliminar el taller")),
          );
        }
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  void _editarTaller(Taller taller) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditarTallerScreen(taller: taller)),
    );

    if (result == true && mounted) {
      _fetchTalleres(); // Recarga la lista
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
              if (resultado == true && mounted) {
                _fetchTalleres();
              }
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
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarTaller(taller),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _eliminarTaller(taller.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
