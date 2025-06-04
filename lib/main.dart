import 'package:app_garagex/features/registro_citas/presentation/bloc/registro_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_garagex/features/cuenta/presentation/screens/themeProvidere.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CitaBloc()),
      ],
      child: const MyApp(),
    ),
  );
}
