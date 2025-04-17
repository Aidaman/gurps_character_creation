// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
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

  Future saveCharacterAs(BuildContext context) async {
    final Character char = context.read<CharacterProvider>().character;

    try {
      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Please select an output file:',
        fileName:
            '${char.personalInfo.playerName}-${char.personalInfo.name}.json',
      );

      if (outputFile == null) {
        return;
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
  }

  Future loadCharacter(BuildContext context) async {
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
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load your character: $e'),
        ),
      );

      rethrow;
    }
  }
}
