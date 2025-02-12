import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/personal_info.dart';
import 'package:gurps_character_creation/services/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/personal_info_service.dart';

class PersonalInfoProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterPersonalInfoService _personalInfoService;

  PersonalInfoProvider(
    CharacterProvider characterProvider,
    CharacterPersonalInfoService personalInfoService,
  )   : _characterProvider = characterProvider,
        _personalInfoService = personalInfoService;

  PersonalInfo get personalInfo => _characterProvider.character.personalInfo;

  String getField(String fieldName) {
    return _personalInfoService.getField(
      _characterProvider.character,
      fieldName,
    );
  }

  void update({
    required String field,
    required dynamic value,
  }) {
    _personalInfoService.update(
      _characterProvider.character,
      field: field,
      value: value,
    );

    _characterProvider.markDirty();
    notifyListeners();
  }
}
