import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/theme_string.dart';

class AppSettings {
  final String _appVersion;
  String get appVersion => _appVersion;

  final ThemeMode _theme;
  ThemeMode get theme => _theme;

  final Duration? _autosaveDelay;
  Duration? get autosaveDelay => _autosaveDelay;

  AppSettings({
    required String appVersion,
    required ThemeMode theme,
    Duration? autosaveDelay,
  })  : _appVersion = appVersion,
        _theme = theme,
        _autosaveDelay = autosaveDelay;

  factory AppSettings.empty() => AppSettings(
        appVersion: '0',
        theme: ThemeMode.system,
        autosaveDelay: const Duration(seconds: 2),
      );

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      appVersion: json['app_version'],
      theme: ThemeModeString.fromString(json['global_theme']),
      autosaveDelay: Duration(
        seconds: int.tryParse(json['autosave_delay_seconds']) ?? 2,
      ),
    );
  }

  factory AppSettings.copyWith(
    AppSettings instance, {
    ThemeMode? theme,
    Duration? autosaveDelay,
  }) =>
      AppSettings(
        appVersion: instance.appVersion,
        theme: theme ?? instance.theme,
        autosaveDelay: autosaveDelay ?? instance._autosaveDelay,
      );

  Map<String, dynamic> toJson() => {
        'app_version': _appVersion,
        'global_theme': _theme.stringValue,
        'autosave_delay_seconds': _autosaveDelay?.inSeconds
      };
}
