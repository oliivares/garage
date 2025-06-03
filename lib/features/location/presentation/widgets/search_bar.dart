import 'package:flutter/material.dart';
import 'package:app_garagex/l10n/app_localizations.dart';

class SearchBarWidget extends StatelessWidget {
  final void Function(String query) onSearch;

  const SearchBarWidget({required this.onSearch, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return TextField(
      controller: controller,
      onSubmitted: onSearch,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchplace,
        hintStyle: TextStyle(color: Colors.black54),
        prefixIcon: const Icon(Icons.search, color: Colors.deepOrangeAccent),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.75),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepOrangeAccent,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.deepOrangeAccent,
            width: 2,
          ),
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }
}
