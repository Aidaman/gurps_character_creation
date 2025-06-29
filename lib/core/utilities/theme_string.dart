import 'package:flutter/material.dart';

extension ThemeModeString on ThemeMode {
  String get stringValue => switch (this) {
        ThemeMode.system => 'system',
        ThemeMode.light => 'light',
        ThemeMode.dark => 'dark',
      };

  static ThemeMode fromString(String str) => switch (str.toLowerCase()) {
        'system' => ThemeMode.system,
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        String() => ThemeMode.system,
      };
}
