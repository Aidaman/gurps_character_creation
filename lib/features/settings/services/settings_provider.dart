import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/settings/models/app_settings.dart';
import 'package:path_provider/path_provider.dart';

class SettingsProvider with ChangeNotifier {
  late AppSettings settings;

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
        saveSettings();
        return settings;
      }

      print('File exists lol');

      settings = AppSettings.fromJson(json.decode(await file.readAsString()));
    } catch (e) {
      print('an error occured...');
      settings = AppSettings.empty();

      rethrow;
    } finally {
      notifyListeners();
    }

    return settings;
  }

  void saveSettings() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/settings.json');

      await file.writeAsString(json.encode(settings.toJson()));
    } catch (e) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }
}
