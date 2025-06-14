import 'dart:convert';
import 'package:app_garagex/features/data/static_data.dart';
import 'package:app_garagex/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CrearTallerScreen extends StatefulWidget {
  const CrearTallerScreen({super.key});

  @override
  State<CrearTallerScreen> createState() => _CrearTallerScreenState();
}

class _CrearTallerScreenState extends State<CrearTallerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _direccionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _emailController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();

  Future<void> _guardarTaller() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? '';

      final jefeTaller = await AuthService.getUsuarioActual();

      final url = Uri.parse('${StaticData.baseUrl}/taller');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "nombre": _nombreController.text.trim(),
          "direccion": _direccionController.text.trim(),
          "telefono": int.tryParse(_telefonoController.text.trim()) ?? 0,
          "email": _emailController.text.trim(),
          "latitud": double.tryParse(_latitudController.text.trim()) ?? 0.0,
          "longitud": double.tryParse(_longitudController.text.trim()) ?? 0.0,
          "jefeTaller": {"id": jefeTaller["usuario"]["id"]},
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      }
      else if (response.statusCode == 302) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error de duplicado en alguno de los campos'),
          ),
        );
      }
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error ${response.statusCode}: ${response.body}'),
          ),
        );
      }
    } catch (e) {
      if (e.toString().contains("duplicate key")) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error de duplicado en alguno de los campos')));
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar taller: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Taller')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _direccionController,
                decoration: const InputDecoration(labelText: 'Dirección'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _telefonoController,
                decoration: const InputDecoration(labelText: 'Teléfono'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) => v!.isEmpty ? 'Campo obligatorio' : null,
              ),
              TextFormField(
                controller: _latitudController,
                decoration: const InputDecoration(labelText: 'Latitud'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _longitudController,
                decoration: const InputDecoration(labelText: 'Longitud'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _guardarTaller,
                child: const Text('Guardar Taller'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
