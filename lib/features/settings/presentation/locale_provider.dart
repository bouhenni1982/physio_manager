import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final localeProvider = StateNotifierProvider<LocaleController, Locale?>((ref) {
  return LocaleController();
});

class LocaleController extends StateNotifier<Locale?> {
  LocaleController() : super(null) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('app_locale');
    if (code == null || code.isEmpty) return;
    final locale = _parseLocale(code);
    if (locale != null) state = locale;
  }

  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove('app_locale');
    } else {
      await prefs.setString(
        'app_locale',
        '${locale.languageCode}_${locale.countryCode ?? ''}',
      );
    }
  }

  Locale? _parseLocale(String code) {
    final parts = code.split('_');
    if (parts.isEmpty) return null;
    if (parts.length == 1) return Locale(parts.first);
    return Locale(parts.first, parts[1].isEmpty ? null : parts[1]);
  }
}
