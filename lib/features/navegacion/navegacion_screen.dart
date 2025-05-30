import 'package:app_garagex/features/cuenta/presentation/screens/cuenta_screen.dart';
import 'package:app_garagex/features/vehiculo/presentation/screens/vehiculo_screen.dart';
import 'package:flutter/material.dart';
import 'package:app_garagex/features/home/presentation/screens/home_screen.dart';
import 'package:app_garagex/features/location/presentation/screens/location_screen.dart';
import 'package:app_garagex/features/registro_citas/presentation/screens/registro_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = const [
    LocalizacionScreen(),
    RegistroScreen(),
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
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: "Ubicación",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Registro"),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage("assets/logo_garagex.png"), size: 40),
            label: "Inicio",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Vehículos",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Cuenta"),
        ],
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
