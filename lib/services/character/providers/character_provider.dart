import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/services/character/providers/aspects_provider.dart';
import 'package:provider/provider.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();

  Character get character => _character;

  bool _isDirty = false;
  bool get isDirty => _isDirty;

  void clearProgress() {
    _character = Character.empty();
    _isDirty = false;
  }

  void updateCharacterMaxPoints(int? newValue) {
    _character.points = newValue ?? _character.points;
    notifyListeners();
  }

  void addSkill(Skill skill) {
    if (_character.skills.any((s) => s.name == skill.name)) {
      return;
    }

    _character.skills.add(Skill.copyWith(skill, investedPoints: 1));

    _isDirty = true;
    notifyListeners();
  }

  void adjustSkillInvestedPoints(Skill skill, int adjustment) {
    if (adjustment <= 0 && skill.investedPoints == 1) {
      return;
    }

    if (character.remainingPoints - adjustment > character.points) {
      return;
    }

    if (character.remainingPoints - adjustment < 0) {
      return;
    }

    skill.investedPoints += adjustment;

    _isDirty = true;
    notifyListeners();
  }

  void adjustSpellInvestedPoints(Spell spell, int adjustment) {
    if (adjustment <= 0 && spell.investedPoints == 1) {
      return;
    }

    if (character.remainingPoints - adjustment > character.points) {
      return;
    }

    if (character.remainingPoints - adjustment < 0) {
      return;
    }

    spell.investedPoints += adjustment;

    _isDirty = true;
    notifyListeners();
  }

  void removeSkill(Skill skill) {
    _character.skills.removeWhere(
      (s) => s.name == skill.name,
    );

    _isDirty = true;
    notifyListeners();
  }

  void refreshSpellUnsatisfiedPrereqs() {
    _character.spells = _character.spells.map((spl) {
      final List<String> unsatisfitedPrerequisitesList = spl.prereqList
          .where(
            (s) => !_character.spells.any(
              (e) => e.name.toLowerCase() == s.toLowerCase(),
            ),
          )
          .toList();

      return Spell.copyWith(
        spl,
        unsatisfitedPrerequisitesList: unsatisfitedPrerequisitesList,
      );
    }).toList();
  }

  void addSpell(Spell spell) {
    if (_character.spells.any((s) => s.name == spell.name)) {
      return;
    }

    _character.spells.add(spell);

    _isDirty = true;
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void addSpellByName(String spellName, BuildContext context) {
    if (_character.spells.any((s) => s.name == spellName)) {
      return;
    }

    final AspectsProvider aspectsProvider =
        Provider.of<AspectsProvider>(context, listen: false);

    if (!aspectsProvider.spells.any((s) => s.name.toLowerCase() == spellName)) {
      return;
    }

    addSpell(aspectsProvider.spells.singleWhere(
      (s) => s.name.toLowerCase() == spellName,
    ));

    notifyListeners();
  }

  void removeSpell(Spell spell) {
    _character.spells.removeWhere(
      (s) => s.name == spell.name,
    );

    _isDirty = true;
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void addArmor(Armor armor) {
    _character.armor.add(armor);

    _isDirty = true;
    notifyListeners();
  }

  void updateArmor(Armor newArmor) {
    _character.armor = _character.armor
        .map(
          (Armor armor) => armor.id == newArmor.id ? newArmor : armor,
        )
        .toList();

    _isDirty = true;
    notifyListeners();
  }

  void removeArmor(Armor armorToRemove) {
    _character.armor.removeWhere(
      (Armor armor) => armor.id == armorToRemove.id,
    );

    _isDirty = true;
    notifyListeners();
  }

  void addPossession(Posession poss) {
    _character.possessions.add(poss);

    _isDirty = true;
    notifyListeners();
  }

  void updatePossession(Posession newPossession) {
    _character.possessions = _character.possessions
        .map(
          (Posession poss) =>
              poss.id == newPossession.id ? newPossession : poss,
        )
        .toList();

    _isDirty = true;
    notifyListeners();
  }

  void removePossession(Posession possessonToRemove) {
    _character.possessions.removeWhere(
      (Posession poss) => poss.id == possessonToRemove.id,
    );

    _isDirty = true;
    notifyListeners();
  }

  void setProfilePicture(String path) {
    _character.personalInfo.avatarURL = path;

    _isDirty = true;
    notifyListeners();
  }

  void markDirty() {
    _isDirty = true;
  }

  void loadCharacterFromJson(Map<String, dynamic> jsonData) {
    _character = Character.fromJson(jsonData);

    notifyListeners();
  }
}
