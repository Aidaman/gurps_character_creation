import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/gear.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';

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
