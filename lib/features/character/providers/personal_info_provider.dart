import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/models/personal_info.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/services/personal_info_service.dart';

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
