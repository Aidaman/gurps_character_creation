import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();

  Character get character => _character;

  void updateCharacterField(String key, String value) {
    switch (key) {
      case 'Players Name':
        _character.playerName = value;
        break;
      case 'Character Name':
        _character.name = value;
        break;
      case 'Age':
        _character.age = int.tryParse(value) ?? _character.age;
        break;
      case 'Height':
        _character.height = int.tryParse(value) ?? _character.height;
        break;
      case 'Weight':
        _character.weight = int.tryParse(value) ?? _character.weight;
        break;
      case 'Size Modifier':
        _character.sizeModifier =
            int.tryParse(value) ?? _character.sizeModifier;
        break;
      case 'Strength':
        _character.strength = _character
            .adjustPrimaryAttribute(
              Attributes.ST,
              double.parse(value),
            )
            .toInt();
      case 'Dexterity':
        _character.dexterity = _character
            .adjustPrimaryAttribute(
              Attributes.DX,
              double.parse(value),
            )
            .toInt();
      case 'IQ':
        _character.iq = _character
            .adjustPrimaryAttribute(
              Attributes.IQ,
              double.parse(value),
            )
            .toInt();
      case 'Health':
        _character.health = _character
            .adjustPrimaryAttribute(
              Attributes.HT,
              double.parse(value),
            )
            .toInt();
      case 'Perception':
        _character.pointsSpentOnPer += int.parse(value);
      case 'Will':
        _character.pointsSpentOnWill += int.parse(value);
      case 'Hit Points':
        _character.pointsSpentOnHP += int.parse(value);
      case 'Fatigue Points':
        _character.pointsSpentOnFP += int.parse(value);
      case 'Basic Speed':
        _character.pointsSpentOnBS += int.parse(value);
      case 'Basic Move':
        _character.pointsSpentOnBM += int.parse(value);
      default:
    }

    notifyListeners();
  }

  void addTrait(Trait trait) {
    final bool isEnoughPoints = trait.basePoints < character.remainingPoints;
    final bool isTraitPresent =
        _character.traits.any((t) => t.name == trait.name);

    if (isTraitPresent || !isEnoughPoints) {
      return;
    }

    _character.traits.add(trait);
    notifyListeners();
  }

  void removeTrait(Trait trait) {
    _character.traits.removeWhere(
      (t) => t.name == trait.name,
    );
    notifyListeners();
  }

  void addSkill(Skill skill) {
    if (_character.skills.any((s) => s.name == skill.name)) {
      return;
    }

    _character.skills.add(Skill.copyWith(skill, investedPoints: 1));
    notifyListeners();
  }

  void adjustSkillInvestedPoints(Skill skill, int adjustment) {
    if (adjustment < 0 && skill.investedPoints == 1) {
      return;
    }

    skill.investedPoints += adjustment;
    notifyListeners();
  }

  void removeSkill(Skill skill) {
    _character.skills.removeWhere(
      (s) => s.name == skill.name,
    );
    notifyListeners();
  }

  void refreshSpellUnsatisfiedPrereqs() {
    _character.spells = List.from(
      _character.spells.map((spl) {
        final List<String> unsatisfitedPrerequisitesList = List.from(
          spl.prereqList.where(
            (s) => !_character.spells.any(
              (e) => e.name.toLowerCase() == s.toLowerCase(),
            ),
          ),
        );

        return Spell.copyWith(
          spl,
          unsatisfitedPrerequisitesList: unsatisfitedPrerequisitesList,
        );
      }),
    );
  }

  void addSpell(Spell spell) {
    if (_character.spells.any((s) => s.name == spell.name)) {
      return;
    }

    _character.spells.add(spell);

    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void removeSpell(Spell spell) {
    _character.spells.removeWhere(
      (s) => s.name == spell.name,
    );
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }
}
