import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:gurps_character_creation/features/equipment/models/legality_class.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/damage_type.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon_damage.dart';

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
        minReach: json['min_reach'] ?? 0,
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

List<HandWeapon> handWeaponsFromJson(String str) => List<HandWeapon>.from(
      json.decode(str).map(
            (dynamic x) => HandWeapon.fromJson(x),
          ),
    );

Future<List<HandWeapon>> loadHandWeapons() async {
  final String response = await rootBundle
      .loadString('assets/Equipment/Mellee_Weapons/BasicSet.json');
  final data = handWeaponsFromJson(response);
  return data;
}

String handWeaponsToJson(List<HandWeapon> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

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
    super.maximumSt,
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
    super.maximumSt,
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
    int? maximumSt,
    int? maxSt,
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
      maximumSt: maximumSt ?? hw.maximumSt,
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
        maximumSt: 0,
        lc: LegalityClass.OPEN,
      );

  factory HandWeapon.fromJson(Map<String, dynamic> json) => HandWeapon(
        name: json['name'],
        price: json['price'] ?? 0,
        weight: json['weight'] ?? 0,
        notes: json['notes'] ?? '',
        damage: WeaponDamage.fromGURPSNotation(json['damage']),
        reach: HandWeaponReach.fromJson(json['reach']),
        associatedSkillName: json['associated_skill_name'] ?? '',
        minimumSt: json['minimum_st'] ?? 0,
        maximumSt: json['maximum_st'] ?? 0,
        lc: json['lc'] == null
            ? LegalityClass.OPEN
            : LegalityClassExtention.fromString(json['lc']),
      );

  static double calculateParry(int skillLevel) {
    if (skillLevel == 0) {
      return 0;
    }

    return (skillLevel ~/ 2) + 3;
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'associated_skill_name': associatedSkillName,
        'lc': lc.stringValue,
      };

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'skill': associatedSkillName,
      };
}
