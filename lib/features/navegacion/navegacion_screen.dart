import 'package:app_garagex/features/cuenta/presentation/screens/cuenta_screen.dart';
import 'package:app_garagex/features/registro_citas/presentation/screens/cita_screen.dart';
import 'package:app_garagex/features/vehiculo/presentation/screens/vehiculo_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/home/presentation/screens/home_screen.dart';
import 'package:app_garagex/features/location/presentation/screens/location_screen.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = const [
    LocalizacionScreen(),
    CitaScreen(),
    HomeScreen(),
    VehiculosScreen(),
    CuentaScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.location_on),
            label: localizations.location,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: localizations.registry, // debes definir esto en .arb
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/logo_garagex.png"),
              size: 40,
            ),
            label: localizations.home, // debes definir esto en .arb
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.directions_car),
            label: localizations.vehicles, // debes definir esto en .arb
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: localizations.account, // debes definir esto en .arb
          ),
        ],
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
