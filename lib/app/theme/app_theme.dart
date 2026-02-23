import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Design tokens
  static const Color _primary = Color(0xFF0B6E8A);
  static const Color _primaryDark = Color(0xFF084F65);
  static const Color _secondary = Color(0xFF2BBFA4);
  static const Color _surface = Color(0xFFF3F7FA);
  static const Color _surfaceContainer = Color(0xFFEAF2F7);
  static const Color _onSurfaceMuted = Color(0xFF5D7482);
  static const Color _cardColor = Colors.white;

  static final ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      secondary: _secondary,
      surface: _surface,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: _surface,

    // ── AppBar ──────────────────────────────────────────────────────────────
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 2,
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: _primaryDark,
        statusBarIconBrightness: Brightness.light,
      ),
    ),

    // ── Cards ───────────────────────────────────────────────────────────────
    cardTheme: CardThemeData(
      color: _cardColor,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 0),
    ),

    // ── Input fields ────────────────────────────────────────────────────────
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
      labelStyle: const TextStyle(color: Color(0xFF607D8B)),
      floatingLabelStyle: const TextStyle(color: _primary),
      hintStyle: TextStyle(color: Colors.grey.shade400),
    ),

    // ── Filled button ───────────────────────────────────────────────────────
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
        elevation: 0,
      ),
    ),

    // ── Outlined button ─────────────────────────────────────────────────────
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: _primary,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        side: const BorderSide(color: _primary, width: 1.4),
        textStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // ── Text button ─────────────────────────────────────────────────────────
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: _primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),

    // ── Chip ────────────────────────────────────────────────────────────────
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      selectedColor: _primary.withValues(alpha: 0.15),
      checkmarkColor: _primary,
      side: BorderSide(color: Colors.grey.shade300),
      labelStyle: const TextStyle(fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),

    // ── Navigation bar ──────────────────────────────────────────────────────
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: _primary.withValues(alpha: 0.15),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: _primary, size: 24);
        }
        return IconThemeData(color: Colors.grey.shade500, size: 22);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const TextStyle(
            color: _primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          );
        }
        return TextStyle(color: Colors.grey.shade500, fontSize: 11);
      }),
      elevation: 8,
      shadowColor: Colors.black26,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    // ── Floating action button ───────────────────────────────────────────────
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primary,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),

    // ── List tile ───────────────────────────────────────────────────────────
    listTileTheme: const ListTileThemeData(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      minVerticalPadding: 8,
    ),

    // ── Divider ─────────────────────────────────────────────────────────────
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 1,
      space: 0,
    ),

    // ── Snack bar ───────────────────────────────────────────────────────────
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: const Color(0xFF1C3A4A),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
    ),

    // ── Dialog ──────────────────────────────────────────────────────────────
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
    ),

    // ── Switch ──────────────────────────────────────────────────────────────
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return _primary;
        return Colors.grey.shade400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return _primary.withValues(alpha: 0.3);
        }
        return Colors.grey.shade200;
      }),
    ),

    // ── Text theme ──────────────────────────────────────────────────────────
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1A2B35),
        letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A2B35),
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Color(0xFF1A2B35),
      ),
      titleMedium: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF263238),
      ),
      titleSmall: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF37474F),
      ),
      bodyLarge: TextStyle(fontSize: 15, color: Color(0xFF37474F)),
      bodyMedium: TextStyle(fontSize: 13, color: Color(0xFF546E7A)),
      bodySmall: TextStyle(fontSize: 12, color: Color(0xFF78909C)),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );

  // Helper: gradient for app bar / hero sections
  static const LinearGradient headerGradient = LinearGradient(
    colors: [_primaryDark, _primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [_primary, _secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Status-to-color helpers used across the app
  static Color statusColor(String status) {
    return switch (status) {
      'completed' => const Color(0xFF2E7D32),
      'missed' => const Color(0xFFC62828),
      'canceled' => const Color(0xFF78909C),
      'scheduled' => _primary,
      _ => _primary,
    };
  }

  static Color statusBgColor(String status) {
    return switch (status) {
      'completed' => const Color(0xFFE8F5E9),
      'missed' => const Color(0xFFFFEBEE),
      'canceled' => const Color(0xFFECEFF1),
      'scheduled' => const Color(0xFFE0F2F8),
      _ => const Color(0xFFE0F2F8),
    };
  }

  static Color get surfaceContainer => _surfaceContainer;
  static Color get onSurfaceMuted => _onSurfaceMuted;
}
