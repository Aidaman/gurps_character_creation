import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/characteristics/aspect.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill_bonus.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_modifier.dart';

List<Trait> traitFromJson(String str) =>
    List<Trait>.from(json.decode(str).map((x) => Trait.fromJson(x)));

String traitToJson(List<Trait> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<Trait>> loadTraits() async {
  final jsonString = await rootBundle.loadString(
    'assets/Advantages/BasicSet.json',
  );
  return traitFromJson(jsonString);
}

class Trait extends Aspect {
  final String type;
  final int basePoints;
  final TraitModifier? modifier;
  final List<TraitCategories> categories;
  final SkillBonus? skillBonus;

  Trait({
    required super.name,
    required this.type,
    required this.basePoints,
    this.modifier,
    required super.reference,
    required this.categories,
    this.skillBonus,
  });

  factory Trait.fromJson(Map<String, dynamic> json) {
    final List<String> categories =
        List<String>.from(json['categories'].map((x) => x));
    return Trait(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      basePoints: json['base_points'] ?? 0,
      modifier: json['modifier'] == null
          ? null
          : TraitModifier.fromJson(json['modifier']),
      reference: json['reference'] ?? '',
      categories: _categoriesFromStringList(categories),
      skillBonus: json['skill_bonus'] == null
          ? null
          : SkillBonus.fromJson(json['skill_bonus']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'base_points': basePoints,
        'modifier': modifier?.toJson(),
        'reference': reference,
        'categories': List<dynamic>.from(categories.map((x) => x)),
        'skill_bonus': skillBonus?.toJson(),
      };

  static List<TraitCategories> _categoriesFromStringList(
    List<String> categoriesStringList,
  ) {
    return List<TraitCategories>.from(
      categoriesStringList
          .map(
            (e) => TraitCategoriesExtension.fromString(e),
          )
          .where(
            (element) => element != TraitCategories.NONE,
          ),
    );
  }
}
