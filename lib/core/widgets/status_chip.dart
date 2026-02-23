import 'package:flutter/material.dart';
import '../../app/theme/app_theme.dart';

class StatusChip extends StatelessWidget {
  final String text;
  final String status;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const StatusChip({
    super.key,
    required this.text,
    required this.status,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? AppTheme.statusColor(status);
    final bg = backgroundColor ?? AppTheme.statusBgColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
