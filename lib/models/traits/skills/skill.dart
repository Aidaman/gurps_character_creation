import 'package:gurps_character_creation/models/traits/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/traits/skills/skill_stat.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';

class Skill extends Trait {
  final SkillStat associatedStat;
  final SkillDifficulty difficulty;
  int investedPoints;

  Skill({
    required super.name,
    required super.description,
    required TraitTypes? traitType,
    required super.cost,
    required this.associatedStat,
    required this.difficulty,
    required this.investedPoints,
  }) : super(traitType: traitType ?? TraitTypes.SKILLS);

  int calculateEffectiveSkill(int primaryAttribute) {
    int skillLevel = 0;

    switch (difficulty) {
      case SkillDifficulty.EASY:
        if (investedPoints >= 4) {
          skillLevel = 1 + ((investedPoints - 4) ~/ 4);
        } else if (investedPoints >= 2) {
          skillLevel = 0;
        } else if (investedPoints >= 1) {
          skillLevel = -1;
        }
        break;

      case SkillDifficulty.AVERAGE:
        if (investedPoints >= 4) {
          skillLevel = 0 + ((investedPoints - 4) ~/ 4);
        } else if (investedPoints >= 2) {
          skillLevel = -1;
        } else if (investedPoints >= 1) {
          skillLevel = -2;
        }
        break;

      case SkillDifficulty.HARD:
        if (investedPoints >= 8) {
          skillLevel = 0 + ((investedPoints - 8) ~/ 4);
        } else if (investedPoints >= 4) {
          skillLevel = -1;
        } else if (investedPoints >= 2) {
          skillLevel = -2;
        } else if (investedPoints >= 1) {
          skillLevel = -3;
        }
        break;

      case SkillDifficulty.VERY_HARD:
        if (investedPoints >= 16) {
          skillLevel = 0 + ((investedPoints - 16) ~/ 4);
        } else if (investedPoints >= 8) {
          skillLevel = -1;
        } else if (investedPoints >= 4) {
          skillLevel = -2;
        } else if (investedPoints >= 2) {
          skillLevel = -3;
        } else if (investedPoints >= 1) {
          skillLevel = -4;
        }
        break;
    }

    return primaryAttribute + skillLevel;
  }
}
