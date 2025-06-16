import 'package:app_garagex/features/location/presentation/bloc/servicio_citas.dart';
import 'package:app_garagex/services/vehiculo_service.dart';
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

  DateTime? _fechaHoraCita;
  List<Map<String, dynamic>> _vehiculosUsuario = [];
  Map<String, dynamic>? _vehiculoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarVehiculosUsuario();
  }

  Future<void> _cargarVehiculosUsuario() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userIdStr = prefs.getString("userId");
      if (userIdStr == null) throw Exception("No hay userId");

      final userId = int.parse(userIdStr);
      final vehiculos = await VehiculoService.obtenerVehiculosDeUsuario(userId);

      setState(() {
        _vehiculosUsuario = vehiculos;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al cargar vehículos: $e')));
    }
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

  Future<String> obtenerToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No se encontró token. Por favor inicia sesión.');
    }
    return token;
  }

  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      if (_fechaHoraCita == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona fecha y hora')),
        );
        return;
      }

      if (_vehiculoSeleccionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor selecciona un vehículo')),
        );
        return;
      }

      try {
        final datos = await obtenerTokenYUsuario();
        final token = datos['token']!;
        final userId = int.parse(datos['userId']!);

        final nuevaCita = {
          'descripcion': _descripcionController.text,
          'fechaHoraCita': _fechaHoraCita!.toIso8601String().split('.').first,
          'estado': 'PENDIENTE',
          'solucion': _solucionController.text,
          'usuario': {'id': userId},
          'vehiculo': {'id': _vehiculoSeleccionado!['id']},
          'taller': {'id': widget.tallerId},
        };

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

  Future<Map<String, String>> obtenerTokenYUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    if (token == null || userId == null) {
      throw Exception('Faltan credenciales. Por favor inicia sesión.');
    }

    return {'token': token, 'userId': userId};
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
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: const InputDecoration(
                  labelText: 'Selecciona un vehículo',
                ),
                items:
                    _vehiculosUsuario.map((vehiculo) {
                      final descripcion =
                          "${vehiculo['marca']} (${vehiculo['matricula']})";
                      return DropdownMenuItem<Map<String, dynamic>>(
                        value: vehiculo,
                        child: Text(descripcion),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    _vehiculoSeleccionado = value;
                  });
                },
                validator:
                    (value) => value == null ? 'Selecciona un vehículo' : null,
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
