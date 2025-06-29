import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/settings/models/app_settings.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  late AppSettings _appSettings;

  AppSettings get settings => _appSettings;
  set settings(AppSettings settings) {
    if (_appSettings.appVersion != settings.appVersion) {
      return;
    }

    _appSettings = settings;
  }

  void deleteSettingsFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/settings.json');

    await file.delete();
  }

  Future<AppSettings> loadSettings() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/settings.json');

      if (!await file.exists()) {
        _appSettings = AppSettings.empty();
        saveSettings();
        return _appSettings;
      }

      print('File exists lol');

      _appSettings =
          AppSettings.fromJson(json.decode(await file.readAsString()));
    } catch (e) {
      print('an error occured...');
      _appSettings = AppSettings.empty();

      rethrow;
    } finally {
      notifyListeners();
    }

    return _appSettings;
  }

  void saveSettings() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/settings.json');

      await file.writeAsString(json.encode(_appSettings.toJson()));
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
