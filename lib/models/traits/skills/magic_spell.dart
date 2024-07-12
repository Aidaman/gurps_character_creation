import 'package:gurps_character_creation/models/traits/skills/skill.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';

class MagicSpell extends Skill {
  MagicSpell(
      {required super.name,
      required super.description,
      required TraitTypes? traitType,
      required super.cost,
      required super.difficulty,
      required super.associatedStat,
      required super.investedPoints})
      : super(traitType: traitType ?? TraitTypes.SPELLS);
}
