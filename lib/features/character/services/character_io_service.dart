// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class CharacterIOService {
  Future saveCharacter(BuildContext context) async {
    final Character char = context.read<CharacterProvider>().character;

    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath =
          '${char.personalInfo.playerName}-${char.personalInfo.name}.json';

      final Uri fileUri = Uri.file('${directory.path}/$filePath');
      final file = File(fileUri.toFilePath());

      await file.writeAsString(jsonEncode(char.toJson()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Character saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save your character: $e'),
        ),
      );

      rethrow;
    }
  }

  /// Saves a character to a user-defined location.
  /// return false on error
  /// return true on success
  Future<bool> saveCharacterAs(BuildContext context) async {
    final Character char = context.read<CharacterProvider>().character;

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Character saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save your character: $e'),
        ),
      );

      rethrow;
    }

    return true;
  }

  /// Loads a character from a JSON file.
  /// return false on error
  /// return true on success
  Future<bool> loadCharacter(BuildContext context) async {
    final CharacterProvider characterProvider =
        context.read<CharacterProvider>();

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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Character loaded successfully!')),
        );

        return true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load your character: $e'),
        ),
      );

      rethrow;
    }

    return false;
  }
}
