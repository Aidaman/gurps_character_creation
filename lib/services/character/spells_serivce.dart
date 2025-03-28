import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/services/character_crud_service.dart';

class CharacterSpellsSerivce extends CharacterCRUDService<Spell> {
  @override
  void add(Character character, Spell item) {
    character.spells.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.spells.removeWhere((Spell spell) => spell.id == id);
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
}
