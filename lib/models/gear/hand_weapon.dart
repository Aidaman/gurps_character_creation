import 'package:gurps_character_creation/models/gear/weapon.dart';

enum HandWeaponParryModifier { POSITIVE, NEGATIVE, NONE }

extension HandWeaponParryModifierStringValues on HandWeaponParryModifier {
  String get stringValue => switch (this) {
        HandWeaponParryModifier.POSITIVE => '+',
        HandWeaponParryModifier.NEGATIVE => '-',
        HandWeaponParryModifier.NONE => '',
      };
}

class HandWeaponParry {
  final int parryValue;
  final HandWeaponParryModifier? modifier;

  const HandWeaponParry({
    required this.parryValue,
    required this.modifier,
  });

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
}
