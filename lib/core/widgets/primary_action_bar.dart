import 'package:flutter/material.dart';

class PrimaryActionBar extends StatelessWidget {
  final bool loading;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  const PrimaryActionBar({
    super.key,
    required this.loading,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (icon == null) {
      return FilledButton(
        onPressed: onPressed,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
