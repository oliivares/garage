import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/screens/editarUsuarioAdmin.dart';
import 'package:app_garagex/services/usuarioSearh_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuscarUsuarioScreen extends StatefulWidget {
  const BuscarUsuarioScreen({super.key});

  @override
  State<BuscarUsuarioScreen> createState() => _BuscarUsuarioScreenState();
}

class _BuscarUsuarioScreenState extends State<BuscarUsuarioScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _sugerencias = [];
  bool _loading = false;

  late UsuarioSearchService _searchService;

  String rolActualUsuario = '';

  @override
  void initState() {
    super.initState();
    _searchService = UsuarioSearchService(client: createIOClient());
    _loadRolActualUsuario();
  }

  void _loadRolActualUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("usuario");
    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        rolActualUsuario = user['rol'] ?? '';
      });
    }
  }

  void _onChanged(String query) async {
    if (query.length < 2) {
      setState(() => _sugerencias = []);
      return;
    }

    setState(() => _loading = true);

    try {
      final resultados = await _searchService.buscarUsuariosPorNombreUsuario(
        query,
      );
      setState(() => _sugerencias = resultados);
    } catch (e) {
      print("ERROR EN BUSQUEDA: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al buscar sugerencias")),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buscar usuario"),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(labelText: "Nombre de usuario"),
              onChanged: _onChanged,
            ),
            const SizedBox(height: 16),
            if (_loading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _sugerencias.length,
                  itemBuilder: (context, index) {
                    final sugerencia = _sugerencias[index];
                    return ListTile(
                      title: Text(sugerencia),
                      onTap: () async {
                        try {
                          final usuarioCompleto = await _searchService
                              .obtenerUsuarioPorNombreUsuario(sugerencia);

                          print("Usuario recibido: $usuarioCompleto");

                          showDialog(
                            context: context,
                            builder:
                                (context) => EditarUsuarioDialog(
                                  usuario: usuarioCompleto,
                                  rolActualUsuario: rolActualUsuario,
                                ),
                          );
                        } catch (e, stackTrace) {
                          print("ERROR al obtener usuario:");
                          print("Exception: $e");
                          print("StackTrace: $stackTrace");

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Error al cargar los datos del usuario: $e",
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
