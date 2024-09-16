import 'package:gurps_character_creation/models/gear/weapon.dart';

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

  RangedWeaponLegalityClass fromString(String string) =>
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

  RangeWeaponShots({
    required this.shotsAvailable,
    this.reloadsBeforeCompleteReload,
  });

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

  WeaponStrengths({
    required this.strengthValue,
    this.isTwoHanded,
    this.hasBonusForHigherStrength,
  });

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

  Range({required this.shortRange, this.longRange});

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
    required this.range,
    required this.accuracy,
    required this.rateOfFire,
    required this.shots,
    required this.bulk,
    required this.recoil,
    required this.st,
    required this.lc,
  });
}
