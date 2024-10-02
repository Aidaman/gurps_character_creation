import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/characteristics/aspect.dart';

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

  final int investedPoints;
  final List<String>? unsatisfitedPrerequisitesList;

  Spell({
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
    int? investedPoints,
  }) : investedPoints = investedPoints ?? 0;

  factory Spell.fromJson(Map<String, dynamic> json) => Spell(
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
        categories: List<String>.from(json['categories'].map((x) => x)),
        prereqList: List<String>.from(json['prereq_list'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'college': college.length > 1 ? college.join('/') : college.first,
        'power_source': powerSource,
        'spell_class': spellClass,
        'casting_cost': castingCost,
        'maintenance_cost': maintenanceCost,
        'casting_time': castingTime,
        'duration': duration,
        'reference': reference,
        'categories': List<String>.from(categories.map((x) => x)),
        'prereq_list': List<String>.from(prereqList.map((x) => x)),
      };

  factory Spell.copyWith(
    Spell spl, {
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
}
