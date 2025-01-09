import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/characteristics/aspect.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill_bonus.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_modifier.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';

List<Trait> traitFromJson(String str) =>
    List<Trait>.from(json.decode(str).map((x) => Trait.fromJson(x)));

String traitToJson(List<Trait> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<Trait>> loadTraits() async {
  final jsonString = await rootBundle.loadString(
    'assets/Traits/BasicSet.json',
  );
  return traitFromJson(jsonString);
}

class Trait extends Aspect {
  final String type;
  final int basePoints;
  final List<TraitModifier>? modifiers;
  final List<TraitModifier>? selectedModifiers;
  final List<TraitCategories> categories;
  final SkillBonus? skillBonus;

  String? _title;

  int get cost {
    if (selectedModifiers == null || selectedModifiers!.isEmpty) {
      return basePoints;
    }

    return selectedModifiers!.fold(
      basePoints,
      (int sum, TraitModifier currentModifier) => sum + currentModifier.cost,
    );
  }

  String get title {
    if (placeholderAspectRegex.hasMatch(name) && _title != null) {
      return _title!;
    }

    return name;
  }

  set title(String? value) {
    _title = value;
  }

  TraitCategories get category {
    if (categories.first == TraitCategories.PERK ||
        categories.first == TraitCategories.QUIRK) {
      return categories.first;
    }

    if (cost < 0) {
      return TraitCategories.DISADVANTAGE;
    }

    return TraitCategories.ADVANTAGE;
  }

  Trait({
    required super.name,
    required this.type,
    required this.basePoints,
    this.modifiers,
    required super.reference,
    required this.categories,
    this.skillBonus,
    this.selectedModifiers,
  });

  factory Trait.fromJson(Map<String, dynamic> json) {
    final List<String> categories =
        List<String>.from(json['categories'].map((x) => x));
    final List<Map<String, dynamic>> modifiers =
        List<Map<String, dynamic>>.from(json['modifiers'].map((x) => x));

    return Trait(
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      basePoints: json['base_points'] ?? 0,
      modifiers: json['modifiers'] == null
          ? null
          : _modifiersFromStringList(modifiers),
      reference: json['reference'] ?? '',
      categories: _categoriesFromStringList(categories),
      skillBonus: json['skill_bonus'] == null
          ? null
          : SkillBonus.fromJson(json['skill_bonus']),
      selectedModifiers: json['selected_modifiers'] == null
          ? null
          : _modifiersFromStringList(modifiers),
    );
  }

  factory Trait.copyWIth(
    Trait trait, {
    String? name,
    String? type,
    int? basePoints,
    List<TraitModifier>? modifiers,
    List<TraitModifier>? selectedModifiers,
    List<TraitCategories>? categories,
    SkillBonus? skillBonus,
    String? reference,
  }) {
    return Trait(
      name: name ?? trait.name,
      type: type ?? trait.type,
      basePoints: basePoints ?? trait.basePoints,
      modifiers: modifiers ?? trait.modifiers,
      selectedModifiers: selectedModifiers ?? trait.selectedModifiers,
      categories: categories ?? trait.categories,
      skillBonus: skillBonus ?? trait.skillBonus,
      reference: reference ?? trait.reference,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'base_points': basePoints,
        'modifier': modifiers == null
            ? null
            : List<dynamic>.from(modifiers!.map((e) => e.toJson())),
        'selected_modifier': modifiers == null
            ? null
            : List<dynamic>.from(modifiers!.map((e) => e.toJson())),
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

  static List<TraitModifier> _modifiersFromStringList(
    List<Map<String, dynamic>> modifiers,
  ) {
    return List<TraitModifier>.from(
      modifiers.map((e) => TraitModifier.fromJson(e)),
    );
  }
}
