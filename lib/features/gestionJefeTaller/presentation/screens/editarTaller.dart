import 'package:flutter/material.dart';
import 'package:app_garagex/services/usuarioSearh_service.dart';
import '../../data/models/taller.dart';

class EditarTallerScreen extends StatefulWidget {
  final Taller taller;

  const EditarTallerScreen({super.key, required this.taller});

  @override
  State<EditarTallerScreen> createState() => _EditarTallerScreenState();
}

class _EditarTallerScreenState extends State<EditarTallerScreen> {
  late TextEditingController nombreController;
  late TextEditingController direccionController;
  late TextEditingController telefonoController;
  late TextEditingController emailController;
  late TextEditingController latitudController;
  late TextEditingController longitudController;
  late TextEditingController searchController;

  List<String> sugerencias = [];
  bool loading = false;
  late UsuarioSearchService searchService;

  @override
  void initState() {
    super.initState();
    final taller = widget.taller;

    nombreController = TextEditingController(text: taller.nombre);
    direccionController = TextEditingController(text: taller.direccion);
    telefonoController = TextEditingController(
      text: taller.telefono.toString(),
    );
    emailController = TextEditingController(text: taller.email);
    latitudController = TextEditingController(text: taller.latitud.toString());
    longitudController = TextEditingController(
      text: taller.longitud.toString(),
    );
    searchController = TextEditingController();

    searchService = UsuarioSearchService(client: createIOClient());
  }

  void _buscarUsuarios(String texto) async {
    if (texto.length < 2) {
      setState(() => sugerencias = []);
      return;
    }

    setState(() => loading = true);
    try {
      final results = await searchService.buscarUsuariosPorNombreUsuario(texto);
      setState(() => sugerencias = results);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Error al buscar usuarios")));
    } finally {
      setState(() => loading = false);
    }
  }

  void _asignarUsuario(String nombreUsuario) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Usuario $nombreUsuario asignado")));
  }

  void _guardarCambios() {
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Taller')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: direccionController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: latitudController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Latitud'),
            ),
            TextField(
              controller: longitudController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Longitud'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: searchController,
              decoration: const InputDecoration(labelText: 'Buscar usuario'),
              onChanged: _buscarUsuarios,
            ),
            const SizedBox(height: 10),
            if (loading)
              const CircularProgressIndicator()
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: sugerencias.length,
                itemBuilder: (context, index) {
                  final user = sugerencias[index];
                  return ListTile(
                    title: Text(user),
                    trailing: IconButton(
                      icon: const Icon(Icons.add, color: Colors.green),
                      onPressed: () => _asignarUsuario(user),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _guardarCambios,
              icon: const Icon(Icons.save),
              label: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }
}
