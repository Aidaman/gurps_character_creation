import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';

class CharacteristicsProvider extends ChangeNotifier {
  List<Trait> _traits = [];
  List<Skill> _skills = [];
  List<Spell> _spells = [];

  List<Trait> get traits => _traits;
  List<Skill> get skills => _skills;
  List<Spell> get spells => _spells;

  Future<void> loadCharacteristics() async {
    if (traits.isEmpty) {
      _traits = await loadTraits();
    }

    if (_skills.isEmpty) {
      _skills = await loadSkills();
    }

    if (_spells.isEmpty) {
      _spells = await loadSpells();
    }

    notifyListeners();
  }
}
