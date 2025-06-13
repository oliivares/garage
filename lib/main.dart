import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_garagex/features/cuenta/presentation/screens/themeProvidere.dart';
import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}
