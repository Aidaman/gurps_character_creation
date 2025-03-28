import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/services/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/skill_service.dart';

class SkillsProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterSkillsService _skillsService;

  SkillsProvider(
    CharacterProvider characterProvider,
    CharacterSkillsService skillsService,
  )   : _characterProvider = characterProvider,
        _skillsService = skillsService;

  void add(Skill s) {
    _skillsService.add(_characterProvider.character, s);

    notifyListeners();
  }

  void delete(Skill s) {
    _skillsService.delete(_characterProvider.character, s.id);

    notifyListeners();
  }

  Skill read(Skill s) {
    return _skillsService.read(_characterProvider.character, s.id);
  }

  List<Skill> readAll() {
    return _skillsService.readAll(_characterProvider.character);
  }

  void update(Skill newSkill) {
    _skillsService.update(_characterProvider.character, newSkill);

    notifyListeners();
  }

  void updateSkillLevel(Skill s, int points) {
    _skillsService.updateSkillLevel(
      _characterProvider.character,
      s,
      points: points,
    );

    notifyListeners();
  }
}
