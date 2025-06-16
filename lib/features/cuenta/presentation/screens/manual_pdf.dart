import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ManualPdfScreen extends StatefulWidget {
  const ManualPdfScreen({super.key});

  @override
  State<ManualPdfScreen> createState() => _ManualPdfScreenState();
}

class _ManualPdfScreenState extends State<ManualPdfScreen> {
  String? pdfPath;

  @override
  void initState() {
    super.initState();
    loadPdfFromAssets();
  }

  Future<void> loadPdfFromAssets() async {
    final bytes = await rootBundle.load('assets/manual_uso.pdf');
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/manual_uso.pdf');

    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);

    setState(() {
      pdfPath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manual de Usuario')),
      body:
          pdfPath == null
              ? const Center(child: CircularProgressIndicator())
              : PDFView(
                filePath: pdfPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
              ),
    );
  }
}
