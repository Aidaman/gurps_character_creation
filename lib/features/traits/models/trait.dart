import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/aspects/models/aspect.dart';
import 'package:gurps_character_creation/features/skills/models/skill_bonus.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';
import 'package:gurps_character_creation/features/traits/models/trait_modifier.dart';
import 'package:uuid/uuid.dart';

List<Trait> traitFromJson(String str) => List<Trait>.from(
      json.decode(str).map(
            (dynamic x) => Trait.fromJson(x),
          ),
    );

String traitToJson(List<Trait> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<List<Trait>> loadTraits() async {
  final jsonString = await rootBundle.loadString(
    'assets/Traits/BasicSet.json',
  );
  return traitFromJson(jsonString);
}

class Trait extends Aspect {
  final int basePoints;
  final List<String> tags;
  final String notes;
  final List<TraitModifier> modifiers;
  final List<TraitModifier> selectedModifiers;
  final TraitCategories _category;
  final SkillBonus? skillBonus;

  final bool canLevel;
  int pointsPerLevel;
  int investedPoints;

  String? _placeholder;

  int get level => investedPoints ~/ pointsPerLevel;

  int get cost {
    if (selectedModifiers.isNotEmpty) {
      return basePoints;
    }

    return selectedModifiers.fold(
      basePoints,
      (int sum, TraitModifier currentModifier) =>
          sum + currentModifier.cost.toInt(),
    );
  }

  String get placeholder {
    if (placeholderAspectRegex.hasMatch(name) && _placeholder != null) {
      return name.replaceFirst(placeholderAspectRegex, _placeholder!);
    }

    return name;
  }

  set placeholder(String? value) {
    _placeholder = value;
  }

  TraitCategories get category {
    if (_category == TraitCategories.PERK ||
        _category == TraitCategories.QUIRK) {
      return _category;
    }

    if (cost < 0) {
      return TraitCategories.DISADVANTAGE;
    }

    return TraitCategories.ADVANTAGE;
  }

  Trait({
    required super.id,
    required super.name,
    required this.tags,
    this.notes = '',
    required this.basePoints,
    required this.modifiers,
    required super.reference,
    required TraitCategories category,
    this.skillBonus,
    required this.selectedModifiers,
    this.canLevel = false,
    this.pointsPerLevel = 0,
    this.investedPoints = 0,
  }) : _category = category;

  factory Trait.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> modifiers = [];
    if (json['modifiers'] != null) {
      modifiers = List.from(json['modifiers'].map((x) => x));
    }

    return Trait(
      id: json['id'] ?? const Uuid().v4(),
      name: json['name'] ?? '',
      notes: json['notes'] ?? '',
      tags: List<String>.from(json['tags'].map((x) => x)),
      basePoints: json['base_points'] ?? 0,
      modifiers:
          json['modifiers'] == null ? [] : modifiersFromStringList(modifiers),
      reference: json['reference'] ?? '',
      category: TraitCategoriesExtension.fromPrice(json['base_points'] ?? 0),
      skillBonus: json['skill_bonus'] == null
          ? null
          : SkillBonus.fromJson(json['skill_bonus']),
      selectedModifiers: json['selected_modifiers'] == null
          ? []
          : modifiersFromStringList(modifiers),
      canLevel: json['can_level'] ?? false,
      pointsPerLevel: json['points_per_level'] ?? 0,
      investedPoints: json['invested_points'] ?? 0,
    );
  }

  factory Trait.copyWIth(
    Trait trait, {
    String? id,
    String? name,
    String? type,
    String? notes,
    int? basePoints,
    List<String>? tags,
    List<TraitModifier>? modifiers,
    List<TraitModifier>? selectedModifiers,
    TraitCategories? category,
    SkillBonus? skillBonus,
    String? reference,
    bool? canLevel,
    int? pointsPerLevel,
    int? investedPoints,
  }) {
    return Trait(
      name: name ?? trait.name,
      notes: notes ?? trait.notes,
      basePoints: basePoints ?? trait.basePoints,
      modifiers: modifiers ?? trait.modifiers,
      selectedModifiers: selectedModifiers ?? trait.selectedModifiers,
      category: category ?? trait.category,
      skillBonus: skillBonus ?? trait.skillBonus,
      reference: reference ?? trait.reference,
      tags: tags ?? trait.tags,
      id: id ?? trait.id,
      canLevel: canLevel ?? trait.canLevel,
      pointsPerLevel: pointsPerLevel ?? trait.pointsPerLevel,
      investedPoints: investedPoints ?? trait.investedPoints,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tags': List.from(tags.map((x) => x)),
        'notes': notes,
        'base_points': basePoints,
        'modifier': List.from(modifiers.map((e) => e.toJson())),
        'selected_modifier': List.from(modifiers.map((e) => e.toJson())),
        'reference': reference,
        'categories': category.stringValue,
        'skill_bonus': skillBonus?.toJson(),
      };

  static List<TraitModifier> modifiersFromStringList(
    List<Map<String, dynamic>> modifiers,
  ) {
    return List<TraitModifier>.from(
      modifiers.map((e) => TraitModifier.fromJson(e)),
    );
  }
}
