import 'package:app_garagex/features/location/presentation/bloc/servicio_citas.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CitasScreen extends StatefulWidget {
  final int tallerId;

  const CitasScreen({super.key, required this.tallerId});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _solucionController = TextEditingController();
  final TextEditingController _vehiculoIdController = TextEditingController();

  DateTime? _fechaHoraCita;
  int? _usuarioId;

  @override
  void initState() {
    super.initState();
    _cargarUsuarioId();
  }

  Future<void> _cargarUsuarioId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    if (userId != null) {
      setState(() {
        _usuarioId = userId;
      });
    } else {
      debugPrint('No se encontró el ID del usuario.');
    }
  }

  Future<String> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No se encontró token. Por favor inicia sesión.');
    }
    return token;
  }

  Future<void> _seleccionarFechaHora() async {
    final DateTime? fecha = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (fecha == null) return;

    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (hora == null) return;

    setState(() {
      _fechaHoraCita = DateTime(
        fecha.year,
        fecha.month,
        fecha.day,
        hora.hour,
        hora.minute,
      );
    });
  }

  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaHoraCita == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona fecha y hora')),
        );
        return;
      }

      if (_usuarioId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo obtener el ID del usuario')),
        );
        return;
      }

      int? vehiculoId = int.tryParse(_vehiculoIdController.text);
      if (vehiculoId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID de vehículo inválido')),
        );
        return;
      }

      final nuevaCita = {
        'descripcion': _descripcionController.text,
        'fechaHoraCita': _fechaHoraCita!.toIso8601String().split('.').first,
        'estado': 'PENDIENTE',
        'solucion': _solucionController.text,
        'vehiculo': {'id': vehiculoId},
        'taller': {'id': widget.tallerId},
        'usuario': {'id': _usuarioId},
      };

      try {
        String token = await obtenerToken();

        final respuesta = await CitaService.crearCita(nuevaCita, token);

        if (!mounted) return;

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(respuesta)));
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar la cita: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agendar cita')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  _fechaHoraCita == null
                      ? 'Seleccionar fecha y hora'
                      : 'Fecha y hora: ${_fechaHoraCita.toString()}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _seleccionarFechaHora,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _solucionController,
                decoration: const InputDecoration(
                  labelText: 'Solución (opcional)',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vehiculoIdController,
                decoration: const InputDecoration(labelText: 'ID del Vehículo'),
                validator:
                    (value) => value!.isEmpty ? 'Campo obligatorio' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _enviarFormulario,
                child: const Text('Guardar Cita'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
