import 'package:gurps_character_creation/features/equipment/models/equipment.dart';
import 'package:gurps_character_creation/features/equipment/models/legality_class.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon_damage.dart';

abstract class Weapon extends Equipment {
  final WeaponDamage damage;
  final LegalityClass lc;
  final String associatedSkillName;
  final String notes;
  final int minimumSt;
  final int? maximumSt;

  Weapon({
    required this.damage,
    required this.lc,
    required this.associatedSkillName,
    required this.minimumSt,
    required this.notes,
    required super.weight,
    required super.name,
    required super.price,
    this.maximumSt,
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
    this.maximumSt,
  }) : super.withId();

  Map<String, dynamic> toJson();
}
