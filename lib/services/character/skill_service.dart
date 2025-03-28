import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/services/character_crud_service.dart';

class CharacterSkillsService extends CharacterCRUDService<Skill> {
  @override
  void add(Character character, Skill item) {
    character.skills.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.skills.removeWhere((Skill skill) => skill.id == id);
  }

  @override
  Skill read(Character character, String id) {
    return character.skills.firstWhere((Skill skill) => skill.id == id);
  }

  @override
  List<Skill> readAll(Character character) {
    return character.skills;
  }

  @override
  void update(Character character, Skill item) {
    character.skills = character.skills.map((Skill skill) {
      if (skill.id == item.id) {
        return item;
      }

      return skill;
    }).toList();
  }

  void increaseSkillLevel(Character character, Skill s, {int points = 1}) {
    if (character.remainingPoints <= points) {
      return;
    }

    s.investedPoints += points;
  }

  void reduceSkillLevel(Character character, Skill s, {int points = 1}) {
    if (s.investedPoints < points) {
      return;
    }

    s.investedPoints -= points;
  }

  void updateSkillLevel(Character character, Skill s, {required int points}) {
    if (points <= 0 && s.investedPoints == 1) {
      return;
    }

    if (character.remainingPoints <= points) {
      return;
    }

    if (character.remainingPoints - points > character.points) {
      return;
    }

    if (character.remainingPoints - points < 0) {
      return;
    }

    s.investedPoints += points;
  }
}
