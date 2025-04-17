import 'package:gurps_character_creation/features/gear/models/gear.dart';
import 'package:gurps_character_creation/features/gear/models/legality_class.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/weapon_damage.dart';

abstract class Weapon extends Gear {
  final WeaponDamage damage;
  final LegalityClass lc;
  final String associatedSkillName;
  final String notes;
  final int minimumSt;

  Weapon({
    required this.damage,
    required this.lc,
    required this.associatedSkillName,
    required this.minimumSt,
    required this.notes,
    required super.weight,
    required super.name,
    required super.price,
  });

  Weapon.withId({
    required this.damage,
    required this.lc,
    required this.associatedSkillName,
    required this.minimumSt,
    required this.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.id,
  }) : super.withId();

  Map<String, dynamic> toJson();
}
