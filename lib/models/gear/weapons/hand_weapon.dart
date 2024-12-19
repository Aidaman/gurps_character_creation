import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';

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

  HandWeapon({
    required this.reach,
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
          maximumRange: 1,
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
      };

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
        'damage': damage.toJson(),
        'reach': reach.toJson(),
        'parry': 0,
        'skill': associatedSkillName,
      };
}
