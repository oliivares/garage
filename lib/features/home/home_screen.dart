import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String userName = '';
  String userRole = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString("usuario");

    if (userJson != null) {
      final user = jsonDecode(userJson);
      setState(() {
        userName = user['nombre'] ?? 'Usuario';
        userRole = user['rol'] ?? 'No definido';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName, style: const TextStyle(fontSize: 18)),
            Text("Rol: $userRole", style: const TextStyle(fontSize: 14)),
          ],
        ),
        backgroundColor: Colors.deepOrangeAccent,
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text("HOME", style: TextStyle(fontSize: 20))),
    );
  }
}
