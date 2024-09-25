import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/gear.dart';

class WeaponDamage {
  final String baseDamage; // e.g., 'sw+2', 'thr-1'
  final DamageType damageType;

  WeaponDamage({
    required this.baseDamage,
    required this.damageType,
  });

  @override
  String toString() => '$baseDamage ${damageType.abbreviatedStringValue}';
}

abstract class Weapon extends Gear {
  final int damage;
  final String notes;

  Weapon({
    required this.damage,
    required this.notes,
    required super.name,
    required super.price,
    required super.weight,
  });

  Weapon.withId({
    required this.damage,
    required this.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.id,
  }) : super.withId();
}
