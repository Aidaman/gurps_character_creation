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
        TraitCategories.ADVANTAGE => Colors.amberAccent,
        TraitCategories.DISADVANTAGE => Colors.redAccent,
        TraitCategories.QUIRK => Colors.indigoAccent,
        TraitCategories.PERK => Colors.purpleAccent,
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
