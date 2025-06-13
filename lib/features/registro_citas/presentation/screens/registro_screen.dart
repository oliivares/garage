import 'package:flutter/material.dart';

class CitaScreen extends StatelessWidget {
  const CitaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Citas"),
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: const Center(
        child: Text(
          "En producción...",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
