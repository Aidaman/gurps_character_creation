import 'dart:io';

import 'package:path_provider/path_provider.dart';

enum ApplicationDirectories {
  APPLICATION_DIRECTORY,
  USER_CONTENT_DIRECTORY,
  USER_CHARACTERS_DIRECTORY,
  USER_ASPECTS_DIRECTORY,
  USER_EQUIPMENT_DIRECTORY,
  USER_CHARACTER_PROFILE_PICTURES_DIRECTORY,
}

extension ApplicationDirectoriesParser on ApplicationDirectories {
  String get stringValue => switch (this) {
        ApplicationDirectories.APPLICATION_DIRECTORY =>
          'gurps_character_composer',
        ApplicationDirectories.USER_CONTENT_DIRECTORY =>
          'gurps_character_composer/user_content',
        ApplicationDirectories.USER_CHARACTERS_DIRECTORY =>
          'gurps_character_composer/user_content/characters',
        ApplicationDirectories.USER_ASPECTS_DIRECTORY =>
          'gurps_character_composer/user_content/aspects',
        ApplicationDirectories.USER_EQUIPMENT_DIRECTORY =>
          'gurps_character_composer/user_content/equipment',
        ApplicationDirectories.USER_CHARACTER_PROFILE_PICTURES_DIRECTORY =>
          'gurps_character_composer/user_content/character_pfps',
      };

  static ApplicationDirectories parseApplicationDirectory(String value) =>
      switch (value) {
        'gurps_character_composer' =>
          ApplicationDirectories.APPLICATION_DIRECTORY,
        'gurps_character_composer/user_content' =>
          ApplicationDirectories.USER_CONTENT_DIRECTORY,
        'gurps_character_composer/user_content/characters' =>
          ApplicationDirectories.USER_CHARACTERS_DIRECTORY,
        'gurps_character_composer/user_content/aspects' =>
          ApplicationDirectories.USER_ASPECTS_DIRECTORY,
        'gurps_character_composer/user_content/equipment' =>
          ApplicationDirectories.USER_EQUIPMENT_DIRECTORY,
        'gurps_character_composer/user_content/character_pfps' =>
          ApplicationDirectories.USER_CHARACTER_PROFILE_PICTURES_DIRECTORY,
        String() => throw const FormatException(),
      };
}

class AppDirectoryService {
  Future ensureDirectories() async {
    var appDocDir = await getApplicationDocumentsDirectory();

    for (var directory in ApplicationDirectories.values) {
      await _ensureDir(Directory('${appDocDir.path}/${directory.stringValue}'));
    }
  }

  Future _ensureDir(Directory dir) async {
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
  }
}
