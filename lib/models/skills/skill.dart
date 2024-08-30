import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/skills/skill_modifier.dart';
import 'package:gurps_character_creation/models/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';

Future<List<Skill>> loadSkills() async {
  final jsonString = await rootBundle.loadString(
    'assets/Skills/BasicSet.json',
  );
  return skillsFromJson(jsonString);
}

List<Skill> skillsFromJson(String str) =>
    List<Skill>.from(json.decode(str).map((x) => Skill.fromJson(x)));

String skillToJson(List<Skill> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Skill {
  final Attributes associatedStat;
  final SkillDifficulty difficulty;
  int investedPoints;

  final String name;
  final String reference;
  final int basePoints;
  final List<String> categories;
  final List<SkillModifier> modifiers;
  final String? specialization;

  Skill({
    required this.name,
    required this.reference,
    required this.difficulty,
    required this.basePoints,
    required this.categories,
    required this.modifiers,
    required this.associatedStat,
    required this.investedPoints,
    this.specialization,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'],
      reference: json['reference'],
      basePoints: int.parse(json['base_points']),
      categories: List<String>.from(json['categories'].map((x) => x)),
      modifiers: List<SkillModifier>.from(
          json['modifiers'].map((x) => SkillModifier.fromJson(x))),
      specialization: json['specialization'],
      investedPoints: json['invested_points'] ?? 0,
      associatedStat: AttributesExtension.fromString(
            json['difficulty'].toString().split('/').first,
          ) ??
          Attributes.NONE,
      difficulty: SkillDifficultyExtension.fromString(
            json['difficulty'].toString().split('/').last,
          ) ??
          SkillDifficulty.NONE,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'reference': reference,
        'difficulty': difficulty,
        'base_points': basePoints,
        'categories': List<dynamic>.from(categories.map((x) => x)),
        'modifiers': List<dynamic>.from(modifiers.map((x) => x.toJson())),
        'specialization': specialization,
      };

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

      case SkillDifficulty.NONE:
        break;
    }

    return primaryAttribute + skillLevel;
  }
}
