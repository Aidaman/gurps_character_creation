import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/services/character/character_crud_service.dart';

class CharacterSpellsSerivce extends CharacterCRUDService<Spell> {
  @override
  void add(Character character, Spell item) {
    if (character.spells.any((s) => s.name == item.name)) {
      return;
    }

    character.spells.add(item);

    refreshSpellUnsatisfiedPrereqs(character);
  }

  @override
  void delete(Character character, String id) {
    character.spells.removeWhere((Spell spell) => spell.id == id);
    refreshSpellUnsatisfiedPrereqs(character);
  }

  @override
  Spell read(Character character, String id) {
    return character.spells.firstWhere((Spell spell) => spell.id == id);
  }

  @override
  List<Spell> readAll(Character character) {
    return character.spells;
  }

  @override
  void update(Character character, Spell item) {
    character.spells = character.spells.map((Spell spell) {
      if (spell.id == item.id) {
        return item;
      }

      return spell;
    }).toList();
    refreshSpellUnsatisfiedPrereqs(character);
  }

  void increaseSpellLevel(Character character, Spell s, {int points = 1}) {
    if (character.remainingPoints <= points) {
      return;
    }

    s.investedPoints += points;
  }

  void reduceSpellLevel(Character character, Spell s, {int points = 1}) {
    if (s.investedPoints < points) {
      return;
    }

    s.investedPoints -= points;
  }

  void refreshSpellUnsatisfiedPrereqs(Character character) {
    character.spells = character.spells.map((spl) {
      final List<String> unsatisfitedPrerequisitesList = spl.prereqList
          .where(
            (s) => !character.spells.any(
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
}
