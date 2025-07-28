import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/services/app_directory_service.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:path_provider/path_provider.dart';

class CharacterRegistryProvider with ChangeNotifier {
  List<Character> characters = [];

  Character readOneById(String id) => characters.firstWhere((x) => x.id == id);

  void addOne(Character newCharacter) {
    characters.add(newCharacter);
    notifyListeners();
  }

  void updateOne(Character newCharacter) {
    characters = characters
        .map((x) => x.id == newCharacter.id ? newCharacter : x)
        .toList();
    notifyListeners();
  }

  void deleteOne(String id) {
    characters = characters.where((x) => x.id != id).toList();
    notifyListeners();
  }

  Future<void> loadCharacters() async {
    if (characters.isNotEmpty) {
      return;
    }

    final Directory directory = await getApplicationDocumentsDirectory();
    final Directory characterDirectory = Directory(
      '${directory.path}/${ApplicationDirectories.USER_CHARACTERS_DIRECTORY.stringValue}',
    );

    if (!await characterDirectory.exists()) {
      throw Exception('User made Characters directory does not exist');
    }

    List<FileSystemEntity> files = characterDirectory.listSync();
    for (FileSystemEntity file in files) {
      if (file is File) {
        try {
          String content = await file.readAsString();
          characters.add(Character.fromJson(json.decode(content)));
        } catch (e) {
          rethrow;
        }
      }
    }

    notifyListeners();
  }
}
