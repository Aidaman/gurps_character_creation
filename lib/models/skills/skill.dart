import 'package:gurps_character_creation/models/traits/skill_bonus.dart';
import 'package:gurps_character_creation/models/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/skills/skill_stat.dart';
import 'package:gurps_character_creation/models/traits/trait_modifier.dart';

class Skill {
  final SkillStat associatedStat;
  final SkillDifficulty difficulty;
  int investedPoints;

  final String name;
  final int basePoints;
  final String type;
  final List<String> categories;
  final SkillBonus? skillBonus;
  final List<TraitModifier> modifiers;

  Skill({
    required this.basePoints,
    required this.skillBonus,
    required this.modifiers,
    required this.name,
    required this.categories,
    required this.type,
    required this.associatedStat,
    required this.difficulty,
    required this.investedPoints,
  });

  int calculateEffectiveSkill(int primaryAttribute) {
    int skillLevel = 0;

    switch (difficulty) {
      case SkillDifficulty.EASY:
        switch (investedPoints) {
          case >= 4:
            skillLevel = 1 + ((investedPoints - 4) ~/ 4);
          case >= 2:
            skillLevel = 1;
          case >= 1:
            skillLevel = 0;
        }
        break;

      case SkillDifficulty.AVERAGE:
        switch (investedPoints) {
          case >= 4:
            skillLevel = 1 + ((investedPoints - 4) ~/ 4);
          case >= 2:
            skillLevel = 0;
          case >= 1:
            skillLevel = -1;
        }
        break;

      case SkillDifficulty.HARD:
        switch (investedPoints) {
          case >= 8:
            skillLevel = 1 + ((investedPoints - 8) ~/ 4);
          case >= 4:
            skillLevel = 0;
          case >= 2:
            skillLevel = -1;
          case >= 1:
            skillLevel = -2;
        }
        break;

      case SkillDifficulty.VERY_HARD:
        switch (investedPoints) {
          case >= 12:
            skillLevel = 1 + ((investedPoints - 12) ~/ 4);
          case >= 8:
            skillLevel = 0;
          case >= 4:
            skillLevel = -1;
          case >= 2:
            skillLevel = -2;
          case >= 1:
            skillLevel = -3;
        }
        break;
    }

    return primaryAttribute + skillLevel;
  }
}
