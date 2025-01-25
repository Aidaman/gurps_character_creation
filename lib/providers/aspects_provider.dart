import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/aspect.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';

class AspectsProvider extends ChangeNotifier {
  List<Trait> _traits = [];
  List<Skill> _skills = [];
  List<Spell> _spells = [];

  List<Trait> get traits => _traits;
  List<Skill> get skills => _skills;
  List<Spell> get spells => _spells;

  List<T> _filterAspectsByNames<T extends Aspect>(
    List<T> list,
  ) {
    final List<T> uniqueEntries = [];

    Set<String> seenNames = {};
    for (T element in list) {
      if (!seenNames.contains(element.name)) {
        seenNames.add(element.name);
        uniqueEntries.add(element);
      }
    }

    return uniqueEntries;
  }

  Future<void> loadCharacteristics() async {
    if (traits.isEmpty) {
      _traits = _filterAspectsByNames(await loadTraits());
    }

    if (_skills.isEmpty) {
      _skills = _filterAspectsByNames(await loadSkills());
    }

    if (_spells.isEmpty) {
      _spells = _filterAspectsByNames(await loadSpells());
    }

    notifyListeners();
  }
}
