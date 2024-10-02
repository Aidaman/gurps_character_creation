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
        TraitCategories.NONE => 'Traits',
        TraitCategories.ADVANTAGE => 'Advantage',
        TraitCategories.DISADVANTAGE => 'Disadvantage',
        TraitCategories.PERK => 'Perk',
        TraitCategories.QUIRK => 'Quirk',
      };

  Color get colorValue => switch (this) {
        TraitCategories.NONE => Colors.white,
        TraitCategories.ADVANTAGE => Colors.amber[400]!,
        TraitCategories.DISADVANTAGE => Colors.pink[400]!,
        TraitCategories.QUIRK => Colors.purple[400]!,
        TraitCategories.PERK => Colors.cyan[400]!,
      };

  IconData get iconValue => switch (this) {
        TraitCategories.NONE => Icons.accessibility_outlined,
        TraitCategories.ADVANTAGE => Icons.add,
        TraitCategories.DISADVANTAGE => Icons.remove,
        TraitCategories.QUIRK => Icons.wb_incandescent_outlined,
        TraitCategories.PERK => Icons.circle_outlined,
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
