import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class L10n {
  static const supportedLocales = <Locale>[
    Locale('ar', 'DZ'),
    Locale('fr', 'FR'),
    Locale('en', 'US'),
  ];

  static final localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Locale localeResolutionCallback(Locale? locale, Iterable<Locale> supported) {
    if (locale == null) return supported.first;
    for (final candidate in supported) {
      if (candidate.languageCode == locale.languageCode) return candidate;
    }
    return supported.first;
  }
}
