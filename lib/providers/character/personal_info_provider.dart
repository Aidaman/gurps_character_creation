import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/personal_info_service.dart';

class PersonalInfoProvider extends ChangeNotifier {
  final CharacterProvider characterProvider;
  final CharacterPersonalInfoService personalInfoService;

  PersonalInfoProvider({
    required this.characterProvider,
    required this.personalInfoService,
  });

  void update({
    required String field,
    required dynamic value,
  }) {
    personalInfoService.update(
      characterProvider.character,
      field: field,
      value: value,
    );

    characterProvider.markDirty();
    notifyListeners();
  }
}
