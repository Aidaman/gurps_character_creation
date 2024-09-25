import 'package:gurps_character_creation/models/gear/weapon.dart';

enum HandWeaponParryModifier { POSITIVE, NEGATIVE, NONE }

extension HandWeaponParryModifierStringValues on HandWeaponParryModifier {
  String get stringValue => switch (this) {
        HandWeaponParryModifier.POSITIVE => '+',
        HandWeaponParryModifier.NEGATIVE => '-',
        HandWeaponParryModifier.NONE => '',
      };

  static HandWeaponParryModifier fromString(String value) =>
      switch (value.toLowerCase()) {
        '+' => HandWeaponParryModifier.POSITIVE,
        '-' => HandWeaponParryModifier.NEGATIVE,
        String() => HandWeaponParryModifier.NONE,
      };
}

class HandWeaponParry {
  final int parryValue;
  final HandWeaponParryModifier? modifier;

  const HandWeaponParry({
    required this.parryValue,
    required this.modifier,
  });

  factory HandWeaponParry.fromJson(Map<String, dynamic> json) =>
      HandWeaponParry(
        parryValue: json['parry_value'],
        modifier: HandWeaponParryModifierStringValues.fromString(
          json['modifier'].toString(),
        ),
      );

  static bool isParry(Map<String, dynamic> json) =>
      json.containsKey('parry_value');

  Map<String, dynamic> toJson() => {
        'parry_value': parryValue,
        'modifier': modifier,
      };

  @override
  String toString() {
    if (modifier != null) {
      return '${modifier!.stringValue}$parryValue';
    }

    return '$parryValue';
  }
}

class HandWeaponReach {
  final int minimalRange;
  final int? maximumRange;

  const HandWeaponReach({
    required this.minimalRange,
    this.maximumRange,
  });

  factory HandWeaponReach.fromJson(Map<String, dynamic> json) =>
      HandWeaponReach(
        minimalRange: json['minimal_range'],
        maximumRange: json['modifier'],
      );

  static bool isReach(Map<String, dynamic> json) =>
      json.containsKey('minimal_range');

  Map<String, dynamic> toJson() => {
        'minimal_range': minimalRange,
        'maximum_range': maximumRange,
      };

  @override
  String toString() {
    if (maximumRange is int) {
      return '$minimalRange-$maximumRange';
    }

    return '$minimalRange';
  }
}

class HandWeapon extends Weapon {
  final HandWeaponReach reach;
  final HandWeaponParry parry;

  HandWeapon({
    required this.reach,
    required this.parry,
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
  });

  HandWeapon.withId({
    required this.reach,
    required this.parry,
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.id,
  }) : super.withId();

  factory HandWeapon.empty() => HandWeapon(
        reach: const HandWeaponReach(
          minimalRange: 0,
          maximumRange: 0,
        ),
        parry: const HandWeaponParry(
          modifier: HandWeaponParryModifier.NONE,
          parryValue: 0,
        ),
        damage: 0,
        notes: '',
        name: '',
        price: 0,
        weight: 0,
      );

  factory HandWeapon.fromJson(Map<String, dynamic> json) => HandWeapon(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        notes: json['notes'],
        damage: json['damage'],
        reach: HandWeaponReach.fromJson(json['reach']),
        parry: HandWeaponParry.fromJson(json['parry']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'damage': damage,
        'reach': reach.toJson(),
        'parry': parry.toJson(),
      };
}
