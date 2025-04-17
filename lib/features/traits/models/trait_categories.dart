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
        TraitCategories.ADVANTAGE => Colors.green.shade300,
        TraitCategories.DISADVANTAGE => Colors.red.shade300,
        TraitCategories.QUIRK => Colors.purple.shade300,
        TraitCategories.PERK => Colors.blue.shade300,
      };

  IconData get iconValue => switch (this) {
        TraitCategories.NONE => Icons.accessibility_outlined,
        TraitCategories.ADVANTAGE => Icons.add,
        TraitCategories.DISADVANTAGE => Icons.remove,
        TraitCategories.QUIRK => Icons.wb_incandescent_outlined,
        TraitCategories.PERK => Icons.circle_outlined,
      };

  static TraitCategories fromPrice(int basePoints) {
    return switch (basePoints) {
      -1 => TraitCategories.QUIRK,
      1 => TraitCategories.PERK,
      0 => TraitCategories.NONE,
      int() => basePoints < 0
          ? TraitCategories.DISADVANTAGE
          : TraitCategories.ADVANTAGE,
    };
  }

  static TraitCategories fromString(String category) {
    return switch (category.toLowerCase()) {
      'advantage' => TraitCategories.ADVANTAGE,
      'disadvantage' => TraitCategories.DISADVANTAGE,
      'perk' => TraitCategories.PERK,
      'quirk' => TraitCategories.QUIRK,
      String() => TraitCategories.NONE,
    };
  }
}
