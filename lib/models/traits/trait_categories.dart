import 'package:flutter/material.dart';

enum TraitCategories {
  NONE,
  ADVANTAGE,
  DISADVANTAGE,
  PERK,
  QUIRK,
}

extension TraitCategoriesExtension on TraitCategories {
  String get stringValue => switch (this) {
        TraitCategories.NONE => '',
        TraitCategories.ADVANTAGE => 'Advantage',
        TraitCategories.DISADVANTAGE => 'Disadvantage',
        TraitCategories.PERK => 'Perk',
        TraitCategories.QUIRK => 'Quirk',
      };

  Color get colorValue => switch (this) {
        TraitCategories.NONE => Colors.white,
        TraitCategories.ADVANTAGE => Colors.amber[800]!,
        TraitCategories.DISADVANTAGE => Colors.red[800]!,
        TraitCategories.QUIRK => Colors.blue[800]!,
        TraitCategories.PERK => Colors.purple[800]!,
      };

  static TraitCategories? fromString(String category) {
    return switch (category.toLowerCase()) {
      'advantage' => TraitCategories.ADVANTAGE,
      'disadvantage' => TraitCategories.DISADVANTAGE,
      'perk' => TraitCategories.PERK,
      'quirk' => TraitCategories.QUIRK,
      String() => TraitCategories.NONE,
    };
  }
}
