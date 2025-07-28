// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/services/app_directory_service.dart';
import 'package:gurps_character_creation/core/services/service_locator.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:path_provider/path_provider.dart';

class CharacterIOService {
  /// Saves a character to a default location.
  /// return false on error
  /// return true on success
  static Future saveCharacter() async {
    final Character char = serviceLocator.get<CharacterProvider>().character;

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${ApplicationDirectories.USER_CHARACTERS_DIRECTORY.stringValue}/${char.id}.json';

      final Uri fileUri = Uri.file('${directory.path}/$filePath');
      final file = File(fileUri.toFilePath());

      await file.writeAsString(jsonEncode(char.toJson()));

      return true;
    } catch (e) {
      throw Exception('Failed to save the Character');
    }
  }

  /// Saves a character to a user-defined location.
  /// return false on error
  /// return true on success
  static Future<bool> saveCharacterAs() async {
    final Character char = serviceLocator.get<CharacterProvider>().character;

    try {
      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName:
            '${char.personalInfo.playerName}-${char.personalInfo.name}.json',
      );

      if (outputFile == null) {
        return false;
      }

      final File file = File(outputFile);

      await file.writeAsString(jsonEncode(char.toJson()));
    } catch (e) {
      throw Exception('Failed to save the Character');
    }

    return true;
  }

  /// Loads a character from a JSON file.
  /// return false on error
  /// return true on success
  static Future<bool> loadCharacterFrom() async {
    final CharacterProvider characterProvider =
        serviceLocator.get<CharacterProvider>();

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final File file = File(result.files.single.path!);
        final String fileContent = await file.readAsString();
        final Map<String, dynamic> jsonData = jsonDecode(fileContent);

        characterProvider.loadCharacterFromJson(jsonData);

        return true;
      }

      return false;
    } catch (e, st) {
      throw Exception('Failed to load the Character $e, $st');
    }
  }
}
