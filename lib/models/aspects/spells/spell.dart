import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/aspects/aspect.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill_difficulty.dart';
import 'package:uuid/uuid.dart';

Future<List<Spell>> loadSpells() async {
  final jsonString = await rootBundle.loadString('assets/Spells/magic.json');
  return spellFromJson(jsonString);
}

List<Spell> spellFromJson(String str) =>
    List<Spell>.from(json.decode(str).map((x) => Spell.fromJson(x)));

String spellToJson(List<Spell> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spell extends Aspect {
  final List<String> college;
  final String powerSource;
  final String spellClass;
  final String castingCost;
  final String maintenanceCost;
  final String castingTime;
  final String duration;
  final List<String> categories;
  final List<String> prereqList;

  int investedPoints;
  final List<String>? unsatisfitedPrerequisitesList;
  final SkillDifficulty difficulty;

  Spell({
    required super.id,
    required super.name,
    required this.college,
    required this.powerSource,
    required this.spellClass,
    required this.castingCost,
    required this.maintenanceCost,
    required this.castingTime,
    required this.duration,
    required super.reference,
    required this.categories,
    required this.prereqList,
    this.unsatisfitedPrerequisitesList,
    this.difficulty = SkillDifficulty.HARD,
    int? investedPoints,
  }) : investedPoints = investedPoints ?? 0;

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
        id: json['id'] ?? const Uuid().v4(),
        name: json['name'],
        college: json['college'].toString().contains('/')
            ? json['college'].toString().split('/')
            : [json['college']],
        powerSource: json['power_source'],
        spellClass: json['spell_class'],
        castingCost: json['casting_cost'],
        maintenanceCost: json['maintenance_cost'] ?? '0',
        castingTime: json['casting_time'],
        duration: json['duration'],
        reference: json['reference'],
        difficulty: SkillDifficulty.HARD,
        categories: List<String>.from(json['categories'].map((x) => x)),
        prereqList: List<String>.from(json['prereq_list'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'college': college.length > 1 ? college.join('/') : college.first,
        'power_source': powerSource,
        'spell_class': spellClass,
        'casting_cost': castingCost,
        'maintenance_cost': maintenanceCost,
        'casting_time': castingTime,
        'duration': duration,
        'reference': reference,
        'difficulty': difficulty.stringValue,
        'categories': List<String>.from(categories.map((x) => x)),
        'prereq_list': List<String>.from(prereqList.map((x) => x)),
      };

  factory Spell.copyWith(
    Spell spl, {
    String? id,
    String? name,
    List<String>? college,
    String? powerSource,
    String? spellClass,
    String? castingCost,
    String? maintenanceCost,
    String? castingTime,
    String? duration,
    String? reference,
    List<String>? categories,
    List<String>? prereqList,
    int? investedPoints,
    List<String>? unsatisfitedPrerequisitesList,
  }) {
    return Spell(
      id: id ?? spl.id,
      name: name ?? spl.name,
      college: college ?? spl.college,
      powerSource: powerSource ?? spl.powerSource,
      spellClass: spellClass ?? spl.spellClass,
      castingCost: castingCost ?? spl.castingCost,
      maintenanceCost: maintenanceCost ?? spl.maintenanceCost,
      castingTime: castingTime ?? spl.castingTime,
      duration: duration ?? spl.duration,
      reference: reference ?? spl.reference,
      categories: categories ?? spl.categories,
      prereqList: prereqList ?? spl.prereqList,
      investedPoints: investedPoints ?? spl.investedPoints,
      unsatisfitedPrerequisitesList:
          unsatisfitedPrerequisitesList ?? spl.unsatisfitedPrerequisitesList,
    );
  }

  int spellEfficiency({required int mageryLevel}) {
    int efficiency = mageryLevel;

    switch (difficulty) {
      case SkillDifficulty.HARD:
        efficiency -= 2;
        efficiency += investedPoints;
        break;

      case SkillDifficulty.VERY_HARD:
        efficiency -= 3;
        efficiency += (investedPoints / 2).floor();
        break;

      default:
        throw ArgumentError(
          'Invalid spell difficulty: $difficulty. Must be "Hard" or "Very Hard".',
        );
    }

    return efficiency;
  }
}
