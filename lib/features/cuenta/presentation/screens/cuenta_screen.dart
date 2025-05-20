import 'package:app_garagex/features/cuenta/presentation/bloc/cuenta_bloc.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/datos_personales/datos_personales_screen.dart';
import 'package:app_garagex/app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CuentaScreen extends StatelessWidget {
  const CuentaScreen({super.key});

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
    return ListTile(
      title: Text(label),
      tileColor: seleccionado ? Colors.grey[300] : null,
      onTap: () {
        MyApp.setLocale(context, Locale(code));
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = CuentaController();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.account),
        backgroundColor: Colors.deepOrangeAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
