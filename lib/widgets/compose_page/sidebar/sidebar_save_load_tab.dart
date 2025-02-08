import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:provider/provider.dart';

class SidebarSaveLoadTab extends StatelessWidget {
  const SidebarSaveLoadTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Save',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(4),
          FilledButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Character'),
            onPressed: () async => await _saveCharacter(context),
          ),
          const Gap(8),
          FilledButton.icon(
            icon: const Icon(Icons.save_as_outlined),
            label: const Text('Save Character As'),
            onPressed: () async => await _saveCharacterAs(context),
          ),
          const Gap(24),
          Text(
            'Load',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          FilledButton.icon(
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Load Character'),
            onPressed: () async => await _loadCharacter(context),
          ),
        ],
      ),
    );
  }

  Future _saveCharacter(BuildContext context) async {
    final Character char =
        Provider.of<CharacterProvider>(context, listen: false).character;

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
    }
  }

  Future _saveCharacterAs(BuildContext context) async {
    final Character char =
        Provider.of<CharacterProvider>(context, listen: false).character;

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
    }
  }

  Future _loadCharacter(BuildContext context) async {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context, listen: false);

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
    }
  }
}
