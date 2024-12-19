import 'package:gurps_character_creation/models/gear/gear.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';

abstract class Weapon extends Gear {
  final WeaponDamage damage;
  final String associatedSkillName;
  final String notes;
  final int minimumSt;

  Weapon({
    required this.damage,
    required this.associatedSkillName,
    required this.minimumSt,
    required this.notes,
    required super.weight,
    required super.name,
    required super.price,
  });

  Weapon.withId({
    required this.damage,
    required this.associatedSkillName,
    required this.minimumSt,
    required this.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.id,
  }) : super.withId();
}
