import 'package:flutter/material.dart';

class CuentaOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const CuentaOption({
    required this.icon,
    required this.title,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}
