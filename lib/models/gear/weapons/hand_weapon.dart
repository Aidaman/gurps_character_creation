import 'dart:math';

import 'package:gurps_character_creation/models/gear/legality_class.dart';
import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';

class HandWeaponReach {
  int? _minReach;

  int? get minReach => _minReach;
  set minReach(int? value) {
    if (value == null) {
      return;
    }

    if (maxReach == 0) {
      _maxReach = value;
      return;
    }

    _minReach = min(_maxReach, value);
    _maxReach = max(_maxReach, value);
  }

  int _maxReach;

  int get maxReach => _maxReach;
  set maxReach(int value) {
    _minReach = min(_maxReach, value);
    _maxReach = max(_maxReach, value);
  }

  HandWeaponReach({
    int? minReach,
    required int maxReach,
  })  : _minReach = minReach,
        _maxReach = maxReach;

  factory HandWeaponReach.fromJson(Map<String, dynamic> json) =>
      HandWeaponReach(
        minReach: json['min_reach'],
        maxReach: json['max_reach'],
      );

  static bool isReach(Map<String, dynamic> json) =>
      json.containsKey('min_reach');

  Map<String, dynamic> toJson() => {
        'min_reach': minReach,
        'max_reach': maxReach,
      };

  @override
  String toString() {
    if (minReach != null && minReach != 0) {
      return '$minReach-$maxReach';
    }

    return '$maxReach';
  }
}

class HandWeapon extends Weapon {
  final HandWeaponReach reach;

  HandWeapon({
    required this.reach,
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required super.minimumSt,
    required super.lc,
  });

  HandWeapon.withId({
    required this.reach,
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required super.minimumSt,
    required super.lc,
    required super.id,
  }) : super.withId();

  factory HandWeapon.copyWith(
    HandWeapon hw, {
    HandWeaponReach? reach,
    WeaponDamage? damage,
    String? notes,
    String? name,
    double? price,
    double? weight,
    String? associatedSkillName,
    int? minimumSt,
    LegalityClass? lc,
  }) {
    return HandWeapon.withId(
      id: hw.id,
      reach: reach ?? hw.reach,
      damage: damage ?? hw.damage,
      notes: notes ?? hw.notes,
      name: name ?? hw.name,
      price: price ?? hw.price,
      weight: weight ?? hw.weight,
      associatedSkillName: associatedSkillName ?? hw.associatedSkillName,
      minimumSt: minimumSt ?? hw.minimumSt,
      lc: lc ?? hw.lc,
    );
  }

  factory HandWeapon.empty() => HandWeapon(
        reach: HandWeaponReach(
          minReach: 0,
          maxReach: 1,
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
        minimumSt: 0,
        lc: LegalityClass.OPEN,
      );

  factory HandWeapon.fromJson(Map<String, dynamic> json) => HandWeapon(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        notes: json['notes'],
        damage: json['damage'],
        reach: HandWeaponReach.fromJson(json['reach']),
        associatedSkillName: json['associated_skill_name'],
        minimumSt: json['minimum_st'],
        lc: LegalityClassExtention.fromString(json['lc']),
      );

  static double calculateParry(int skillLevel) {
    if (skillLevel == 0) {
      return 0;
    }

    return (skillLevel ~/ 2) + 3;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'associated_skill_name': associatedSkillName,
        'lc': lc,
      };

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'parry': 0,
        'skill': associatedSkillName,
        'lc': lc,
      };
}
