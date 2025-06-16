import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class AyudaScreen extends StatelessWidget {
  const AyudaScreen({super.key});

  Future<void> _downloadAndOpenPdf(BuildContext context) async {
    final url =
        'https://www.example.com/manual_de_uso.pdf'; // Reemplaza con tu URL real
    final fileName = 'manual_de_uso.pdf';

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName';

      final file = File(filePath);
      if (!file.existsSync()) {
        final response = await Dio().download(url, filePath);
      }

      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo abrir el archivo PDF')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al descargar el PDF: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ayuda"),
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: "Descargar manual PDF",
            onPressed: () => _downloadAndOpenPdf(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text(
              "Manual de Uso de la Aplicación",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text("1. Inicio de sesión:\nIngresa tu usuario y contraseña."),
            SizedBox(height: 8),
            Text(
              "2. Ver tus datos personales:\nAccede desde el menú 'Datos personales'.",
            ),
            SizedBox(height: 8),
            Text(
              "3. Cambiar idioma o tema:\nPuedes cambiarlo desde el menú 'Cuenta'.",
            ),
            SizedBox(height: 8),
            Text(
              "4. Citas:\nConsulta, crea o elimina tus citas desde la sección correspondiente.",
            ),
            SizedBox(height: 8),
            Text(
              "5. Administración:\nLos usuarios administradores pueden gestionar usuarios.",
            ),
            SizedBox(height: 8),
            Text(
              "6. Jefes de taller:\nPueden consultar y gestionar sus talleres.",
            ),
            SizedBox(height: 12),
            Text(
              "¿Necesitas más ayuda?\nContáctanos a soporte@garagex.com",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
