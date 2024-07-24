import 'dart:convert';

import 'package:flutter/services.dart';

Future<List<Spell>> loadSpells() async {
  final jsonString = await rootBundle.loadString('assets/Spells/magic.json');
  return spellFromJson(jsonString);
}

List<Spell> spellFromJson(String str) =>
    List<Spell>.from(json.decode(str).map((x) => Spell.fromJson(x)));

String spellToJson(List<Spell> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Spell {
  final String name;
  final List<String> college;
  final String powerSource;
  final String spellClass;
  final String castingCost;
  final String maintenanceCost;
  final String castingTime;
  final String duration;
  final String reference;
  final List<String> categories;
  final List<String> prereqList;

  Spell({
    required this.name,
    required this.college,
    required this.powerSource,
    required this.spellClass,
    required this.castingCost,
    required this.maintenanceCost,
    required this.castingTime,
    required this.duration,
    required this.reference,
    required this.categories,
    required this.prereqList,
  });

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
}
