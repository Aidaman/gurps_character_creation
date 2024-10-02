import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';

enum RangedWeaponLegalityClass {
  BANNED,
  MILITARY,
  RESTRICTED,
  LICENSED,
  OPEN,
  NONE
}

extension RangedWeaponLegalityClassExtention on RangedWeaponLegalityClass {
  String get stringValue => switch (this) {
        RangedWeaponLegalityClass.BANNED => 'Banned',
        RangedWeaponLegalityClass.MILITARY => 'Military',
        RangedWeaponLegalityClass.RESTRICTED => 'Restricted',
        RangedWeaponLegalityClass.LICENSED => 'Licensed',
        RangedWeaponLegalityClass.OPEN => 'Open',
        RangedWeaponLegalityClass.NONE => 'NONE',
      };

  String get abbreviatedStringValue => switch (this) {
        RangedWeaponLegalityClass.BANNED => 'LC0',
        RangedWeaponLegalityClass.MILITARY => 'LC1',
        RangedWeaponLegalityClass.RESTRICTED => 'LC2',
        RangedWeaponLegalityClass.LICENSED => 'LC3',
        RangedWeaponLegalityClass.OPEN => 'LC4',
        RangedWeaponLegalityClass.NONE => 'NONE',
      };

  static RangedWeaponLegalityClass fromString(String string) =>
      switch (string.toLowerCase()) {
        'banned' => RangedWeaponLegalityClass.BANNED,
        'military' => RangedWeaponLegalityClass.MILITARY,
        'restricted' => RangedWeaponLegalityClass.RESTRICTED,
        'licensed' => RangedWeaponLegalityClass.LICENSED,
        'open' => RangedWeaponLegalityClass.OPEN,
        String() => RangedWeaponLegalityClass.NONE,
      };
}

class RangeWeaponShots {
  final int shotsAvailable;
  final int? reloadsBeforeCompleteReload;

  const RangeWeaponShots({
    required this.shotsAvailable,
    this.reloadsBeforeCompleteReload,
  });

  factory RangeWeaponShots.fromJson(Map<String, dynamic> json) =>
      RangeWeaponShots(
        shotsAvailable: json['shots_available'],
        reloadsBeforeCompleteReload: json['reloads_before_complete_reload'],
      );

  static isShots(Map<String, dynamic> json) =>
      json.containsKey('shots_available');

  Map<String, dynamic> toJson() => {
        'shots_available': shotsAvailable,
        'reloads_before_complete_reload': reloadsBeforeCompleteReload
      };

  @override
  String toString() {
    if (reloadsBeforeCompleteReload != null) {
      return '$shotsAvailable (${reloadsBeforeCompleteReload!})';
    }

    return '$shotsAvailable';
  }
}

class WeaponStrengths {
  final int strengthValue;
  final bool? isTwoHanded;
  final bool? hasBonusForHigherStrength;

  const WeaponStrengths({
    required this.strengthValue,
    this.isTwoHanded,
    this.hasBonusForHigherStrength,
  });

  factory WeaponStrengths.fromJson(Map<String, dynamic> json) =>
      WeaponStrengths(
        strengthValue: json['strength_value'],
        hasBonusForHigherStrength: json['has_bonus_for_higher_strength'],
        isTwoHanded: json['is_two_handed'],
      );

  static bool isWeaponStrengths(Map<String, dynamic> json) =>
      json.containsKey('strength_value');

  Map<String, dynamic> toJson() => {
        'strength_value': strengthValue,
        'has_bonus_for_higher_strength': hasBonusForHigherStrength,
        'is_two_handed': isTwoHanded,
      };

  @override
  String toString() {
    String result = strengthValue.toString();

    if (hasBonusForHigherStrength == true) {
      result += '+';
    }

    if (isTwoHanded == true) {
      result += '†';
    }

    return result;
  }
}

class Range {
  final int shortRange;
  final int? longRange;

  const Range({required this.shortRange, this.longRange});

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        shortRange: json['short_range'],
        longRange: json['long_range'],
      );

  static isRange(Map<String, dynamic> json) => json.containsKey('short_range');

  Map<String, dynamic> toJson() => {
        'short_range': shortRange,
        'long_range': longRange,
      };

  @override
  String toString() {
    if (longRange != null) {
      return '$shortRange/$longRange';
    }

    return '$shortRange';
  }
}

class RangedWeapon extends Weapon {
  final Range range;
  final int accuracy;
  final int rateOfFire;
  final RangeWeaponShots shots;
  final int bulk;
  final int recoil;
  final WeaponStrengths st;
  final RangedWeaponLegalityClass lc;

  RangedWeapon({
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required this.range,
    required this.accuracy,
    required this.rateOfFire,
    required this.shots,
    required this.bulk,
    required this.recoil,
    required this.st,
    required this.lc,
    required super.minimumSt,
  });

  RangedWeapon.withId({
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required super.minimumSt,
    required this.range,
    required this.accuracy,
    required this.rateOfFire,
    required this.shots,
    required this.bulk,
    required this.recoil,
    required this.st,
    required this.lc,
    required super.id,
  }) : super.withId();

  factory RangedWeapon.empty() => RangedWeapon(
        damage: WeaponDamage(
          attackType: AttackTypes.THRUST,
          modifier: 0,
          damageType: DamageType.NONE,
        ),
        notes: '',
        name: '',
        price: 0,
        weight: 0,
        range: const Range(shortRange: 0, longRange: 0),
        accuracy: 0,
        rateOfFire: 0,
        shots: const RangeWeaponShots(
          shotsAvailable: 0,
          reloadsBeforeCompleteReload: 0,
        ),
        bulk: 0,
        recoil: 0,
        st: const WeaponStrengths(
          strengthValue: 0,
          hasBonusForHigherStrength: false,
          isTwoHanded: false,
        ),
        lc: RangedWeaponLegalityClass.NONE,
        associatedSkillName: '',
        minimumSt: 10,
      );

  // factory RangedWeapon.fromJson() => {};

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'accuracy': accuracy,
        'rate_of_fire': rateOfFire,
        'bulk': bulk,
        'recoil': recoil,
        'range': range.toJson(),
        'shots': shots.toJson(),
        'st': st.toJson(),
        'lc': lc.stringValue,
      };

  Map<String, dynamic> toDataTableColumns() => {
        'name': name,
        'price': price,
        'weight': weight,
        'accuracy': accuracy,
        'ROF': rateOfFire,
        'recoil': recoil,
        'range': range.toJson(),
        'shots': shots.toJson(),
        'st': st.toJson(),
      };
}
