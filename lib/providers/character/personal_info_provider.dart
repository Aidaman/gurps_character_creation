import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/personal_info_service.dart';

class PersonalInfoProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterPersonalInfoService _personalInfoService;

  PersonalInfoProvider({
    required CharacterProvider characterProvider,
    required CharacterPersonalInfoService personalInfoService,
  })  : _characterProvider = characterProvider,
        _personalInfoService = personalInfoService;

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
