import 'package:gurps_character_creation/models/aspects/skills/skill_bonus.dart';

class TraitModifier {
  final String name;
  final int cost;
  final String affects;
  final String reference;
  final SkillBonus? skillBonus;

  TraitModifier({
    required this.name,
    required this.cost,
    required this.affects,
    required this.reference,
    this.skillBonus,
  });

  factory TraitModifier.fromJson(Map<String, dynamic> json) => TraitModifier(
        name: json['name'] ?? '',
        cost: json['cost'] ?? 0,
        affects: json['affects'] ?? 'total',
        reference: json['reference'] ?? '',
        skillBonus: json['skill_bonus'] == null
            ? null
            : SkillBonus.fromJson(json['skill_bonus']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'cost': cost,
        'affects': affects,
        'reference': reference,
        'skill_bonus': skillBonus?.toJson(),
      };
}
