import 'dart:convert';
import 'package:app_garagex/features/cuenta/presentation/bloc/cuenta_bloc.dart';
import 'package:app_garagex/features/cuenta/presentation/screens/ayuda.dart';
import 'package:app_garagex/features/cuenta/presentation/screens/manual_pdf.dart';
import 'package:app_garagex/features/cuenta/presentation/screens/themeProvidere.dart';
import 'package:app_garagex/features/datos_personales/presentation/screens/datos_personales_screen.dart';
import 'package:app_garagex/features/gestionJefeTaller/presentation/screens/talleres.dart';
import 'package:app_garagex/features/gestionUsuarioAdmin/presentation/screens/busquedaUsuario.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/app.dart';
import 'package:app_garagex/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class CuentaScreen extends StatefulWidget {
  const CuentaScreen({super.key});

  @override
  State<CuentaScreen> createState() => _CuentaScreenState();
}

class _CuentaScreenState extends State<CuentaScreen> {
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

  void _mostrarSelectorIdioma(BuildContext context) async {
    final controller = CuentaController();
    final actual = await controller.obtenerIdiomaActual();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _opcionIdioma(
                context,
                'es',
                AppLocalizations.of(context)!.spanish,
                actual == 'es',
              ),
              _opcionIdioma(
                context,
                'en',
                AppLocalizations.of(context)!.english,
                actual == 'en',
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _opcionIdioma(
    BuildContext context,
    String code,
    String label,
    bool seleccionado,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: seleccionado ? Colors.deepOrange : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(label),
        tileColor: seleccionado ? Colors.grey[300] : null,
        onTap: () {
          MyApp.setLocale(context, Locale(code));
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = CuentaController();
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account),
        backgroundColor: Colors.deepOrangeAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Datos del usuario
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Rol: $userRole",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.person),
              title: Text(AppLocalizations.of(context)!.personalData),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const DatosPersonalesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.language),
              title: Text(AppLocalizations.of(context)!.language),
              onTap: () => _mostrarSelectorIdioma(context),
            ),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(
                themeProvider.isDarkMode
                    ? AppLocalizations.of(context)!.lightMode
                    : AppLocalizations.of(context)!.darkMode,
              ),
              onTap: () {
                themeProvider.toggleTheme();
              },
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManualPdfScreen()),
                );
              },
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Ver manual en PDF"),
            ),
            if (userRole == "ADMINISTRADOR" || userRole == "JEFE_TALLER") ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text("Gestión de usuarios (búsqueda)"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const BuscarUsuarioScreen(),
                    ),
                  );
                },
              ),
            ],

            // Botón extra solo para jefe de taller
            if (userRole == "JEFE_TALLER") ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.garage),
                title: const Text("Mis Talleres"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MisTalleresScreen(),
                    ),
                  );
                },
              ),
            ],

            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(AppLocalizations.of(context)!.logout),
              onTap: () => controller.cerrarSesion(context),
            ),
          ],
        ),
      ),
    );
  }
}
