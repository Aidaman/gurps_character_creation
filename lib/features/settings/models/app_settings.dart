import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/theme_string.dart';

class AppSettings {
  final String _appVersion;
  get appVersion => _appVersion;

  final ThemeMode _theme;
  get theme => _theme;

  AppSettings({required String appVersion, required ThemeMode theme})
      : _appVersion = appVersion,
        _theme = theme;

  factory AppSettings.empty() =>
      AppSettings(appVersion: '0', theme: ThemeMode.system);

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        appVersion: json['app_version'],
        theme: ThemeModeString.fromString(json['global_theme']),
      );

  factory AppSettings.copyWith(
    AppSettings instance, {
    ThemeMode? theme,
  }) =>
      AppSettings(
        appVersion: instance.appVersion,
        theme: theme ?? instance.theme,
      );

  Map<String, dynamic> toJson() => {
        'app_version': _appVersion,
        'global_theme': _theme.stringValue,
      };
}
