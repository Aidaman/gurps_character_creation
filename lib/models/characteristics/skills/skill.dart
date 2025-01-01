import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/characteristics/aspect.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill_modifier.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';

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

class _SkillThreshold {
  final int threshold;
  final int modifier;

  const _SkillThreshold({
    required this.threshold,
    required this.modifier,
  });
}

class Skill extends Aspect {
  final Attributes associatedAttribute;
  final SkillDifficulty difficulty;
  int investedPoints;

  set investedPoint(int value) {
    if (value < 1) {
      return;
    }

    if (investedPoints - value < 1) {
      investedPoint = 1;
    }

    investedPoint = value;
  }

  final int basePoints;
  final List<String> categories;
  final List<SkillModifier> modifiers;
  final String? specialization;

  Skill({
    required super.name,
    required super.reference,
    required this.difficulty,
    required this.basePoints,
    required this.categories,
    required this.modifiers,
    required this.associatedAttribute,
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
      associatedAttribute: AttributesExtension.fromString(
            json['difficulty'].toString().split('/').first,
          ) ??
          Attributes.NONE,
      difficulty: SkillDifficultyExtension.fromString(
            json['difficulty'].toString().split('/').last,
          ) ??
          SkillDifficulty.NONE,
    );
  }

  factory Skill.copyWith(
    Skill skill, {
    String? name,
    String? reference,
    int? basePoints,
    List<String>? categories,
    List<SkillModifier>? modifiers,
    String? specialization,
    int? investedPoints,
    Attributes? associatedAttribute,
    SkillDifficulty? difficulty,
  }) {
    return Skill(
      name: name ?? skill.name,
      reference: reference ?? skill.reference,
      basePoints: basePoints ?? skill.basePoints,
      categories: categories ?? skill.categories,
      modifiers: modifiers ?? skill.modifiers,
      specialization: specialization ?? skill.specialization,
      investedPoints: investedPoints ?? skill.investedPoints,
      associatedAttribute: associatedAttribute ?? skill.associatedAttribute,
      difficulty: difficulty ?? skill.difficulty,
    );
  }

  factory Skill.empty() => Skill(
        name: '',
        reference: '',
        difficulty: SkillDifficulty.NONE,
        basePoints: 0,
        categories: [],
        modifiers: [],
        associatedAttribute: Attributes.NONE,
        investedPoints: 0,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'reference': reference,
        'difficulty': difficulty,
        'base_points': basePoints,
        'categories': List<dynamic>.from(categories.map((x) => x)),
        'modifiers': List<dynamic>.from(modifiers.map((x) => x.toJson())),
        'specialization': specialization,
      };

  static const Map<SkillDifficulty, List<_SkillThreshold>>
      _skillDifficultyThresholds = {
    SkillDifficulty.NONE: [],
    SkillDifficulty.EASY: [
      _SkillThreshold(
        threshold: 0,
        modifier: 0,
      ),
      _SkillThreshold(
        threshold: 2,
        modifier: 1,
      ),
      _SkillThreshold(
        threshold: 4,
        modifier: 2,
      ),
    ],
    SkillDifficulty.AVERAGE: [
      _SkillThreshold(
        threshold: 0,
        modifier: -1,
      ),
      _SkillThreshold(
        threshold: 2,
        modifier: 0,
      ),
      _SkillThreshold(
        threshold: 4,
        modifier: 1,
      ),
    ],
    SkillDifficulty.HARD: [
      _SkillThreshold(
        threshold: 0,
        modifier: -2,
      ),
      _SkillThreshold(
        threshold: 2,
        modifier: -1,
      ),
      _SkillThreshold(
        threshold: 4,
        modifier: 0,
      ),
      _SkillThreshold(
        threshold: 8,
        modifier: 1,
      ),
    ],
    SkillDifficulty.VERY_HARD: [
      _SkillThreshold(
        threshold: 0,
        modifier: -3,
      ),
      _SkillThreshold(
        threshold: 2,
        modifier: -2,
      ),
      _SkillThreshold(
        threshold: 4,
        modifier: -1,
      ),
      _SkillThreshold(
        threshold: 8,
        modifier: 0,
      ),
      _SkillThreshold(
        threshold: 12,
        modifier: 1,
      ),
    ],
  };

  int skillLevel(int characterAttributeValue) {
    return characterAttributeValue + skillEfficiency;
  }

  int get skillEfficiency {
    List<_SkillThreshold>? thresholds = _skillDifficultyThresholds[difficulty];

    if (thresholds == null) {
      return 0;
    }

    if (investedPoints > thresholds.last.threshold) {
      return thresholds.last.modifier +
          ((investedPoints - thresholds.last.threshold) ~/ 4);
    }

    int efficiency = thresholds.first.modifier;

    for (int i = 0; i < thresholds.length; i++) {
      int threshold = thresholds[i].threshold;

      if (investedPoints >= threshold) {
        efficiency = thresholds[i].modifier;
      }
    }

    return efficiency;
  }
}
