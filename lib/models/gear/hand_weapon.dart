import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';

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
        maximumRange: json['maximum_range'],
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
    required super.associatedSkillName,
    required super.minimumSt,
  });

  HandWeapon.withId({
    required this.reach,
    required this.parry,
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required super.minimumSt,
    required super.id,
  }) : super.withId();

  factory HandWeapon.copyWith(
    HandWeapon hw, {
    HandWeaponReach? reach,
    HandWeaponParry? parry,
    WeaponDamage? damage,
    String? notes,
    String? name,
    double? price,
    double? weight,
    String? associatedSkillName,
    int? minimumSt,
  }) {
    return HandWeapon(
      reach: reach ?? hw.reach,
      parry: parry ?? hw.parry,
      damage: damage ?? hw.damage,
      notes: notes ?? hw.notes,
      name: name ?? hw.name,
      price: price ?? hw.price,
      weight: weight ?? hw.weight,
      associatedSkillName: associatedSkillName ?? hw.associatedSkillName,
      minimumSt: minimumSt ?? hw.minimumSt,
    );
  }

  factory HandWeapon.empty() => HandWeapon(
        reach: const HandWeaponReach(
          minimalRange: 0,
          maximumRange: 0,
        ),
        parry: const HandWeaponParry(
          modifier: HandWeaponParryModifier.NONE,
          parryValue: 0,
        ),
        damage: WeaponDamage(
          attackType: AttackTypes.THRUST,
          modifier: 0,
          damageType: DamageType.NONE,
        ),
        notes: '',
        name: '',
        price: 0,
        weight: 0,
        associatedSkillName: '',
        minimumSt: 10,
      );

  factory HandWeapon.fromJson(Map<String, dynamic> json) => HandWeapon(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        notes: json['notes'],
        damage: json['damage'],
        reach: HandWeaponReach.fromJson(json['reach']),
        parry: HandWeaponParry.fromJson(json['parry']),
        associatedSkillName: json['associated_skill_name'],
        minimumSt: json['minimum_st'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'parry': parry.toJson(),
        'associated_skill_name': associatedSkillName,
      };
}
