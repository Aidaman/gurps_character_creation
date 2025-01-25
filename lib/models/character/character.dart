import 'package:gurps_character_creation/models/character/attributes_scores.dart';
import 'package:gurps_character_creation/models/character/personal_info.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/models/gear/legality_class.dart';
import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';
import 'package:uuid/uuid.dart';

class Character {
  String id;
  String gameId;
  int points;
  String playerName;

  PersonalInfo personalInfo;
  AttributesScores attributes;

  List<Skill> skills;
  List<Trait> traits;
  List<Spell> spells;

  List<Weapon> weapons;
  List<Armor> armor;
  List<Posession> possessions;

  int get remainingPoints {
    int total = 0;
    total += traits
        .map(
          (Trait t) => t.cost,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );
    total += skills
        .map(
          (Skill s) => s.investedPoints,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );
    total += spells
        .map(
          (Spell s) => s.investedPoints,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );

    total += Attributes.values.fold(
      0,
      (sum, attr) => sum + attributes.getPointsInvestedIn(attr),
    );

    return points - total;
  }

  Character({
    required this.gameId,
    required this.points,
    required this.playerName,
    required this.personalInfo,
    required this.attributes,
    required this.skills,
    required this.traits,
    required this.spells,
    required this.weapons,
    required this.armor,
    required this.possessions,
  }) : id = const Uuid().v4();

  Character.withId({
    required this.id,
    required this.gameId,
    required this.points,
    required this.playerName,
    required this.personalInfo,
    required this.attributes,
    required this.skills,
    required this.traits,
    required this.spells,
    required this.weapons,
    required this.armor,
    required this.possessions,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character.withId(
        id: json['id'],
        gameId: json['gameId'],
        playerName: json['player_name'],
        personalInfo: PersonalInfo.fromJson(json['personal_info']),
        attributes: AttributesScores.fromJson(json['attributes']),
        points: json['po  ints'],
        skills: List<Skill>.from(json['skills'].map((x) => x)),
        traits: List<Trait>.from(json['traits'].map((x) => x)),
        spells: List<Spell>.from(json['spells'].map((x) => x)),
        weapons: List<Weapon>.from(json['weapons'].map((x) => x)),
        armor: List<Armor>.from(json['armor'].map((x) => x)),
        possessions: List<Posession>.from(json['possessions'].map((x) => x)),
      );

  factory Character.empty() => Character(
        gameId: 'random',
        points: 100,
        personalInfo: PersonalInfo(),
        attributes: AttributesScores(),
        playerName: '',
        skills: [],
        traits: [],
        spells: [],
        armor: [],
        weapons: [
          HandWeapon(
            name: 'Bite',
            associatedSkillName: 'Brawling',
            damage: WeaponDamage(
              attackType: AttackTypes.THRUST,
              damageType: DamageType.CUTTING,
              modifier: -1,
            ),
            minimumSt: 10,
            price: 0,
            weight: 0,
            reach: HandWeaponReach(
              maxReach: 1,
            ),
            notes: 'A plain bite, anybody can do it, unless they have no teeth',
            lc: LegalityClass.OPEN,
          ),
          HandWeapon(
            name: 'Punch',
            associatedSkillName: 'Brawling',
            damage: WeaponDamage(
              attackType: AttackTypes.THRUST,
              damageType: DamageType.CRUSHING,
              modifier: 0,
            ),
            minimumSt: 10,
            price: 0,
            weight: 0,
            reach: HandWeaponReach(
              maxReach: 1,
            ),
            notes:
                'A punch with a bare hand, when there is no weapon what else you left but your own limbs?',
            lc: LegalityClass.OPEN,
          ),
          HandWeapon(
            name: 'Kick',
            associatedSkillName: 'Brawling',
            damage: WeaponDamage(
              attackType: AttackTypes.SWING,
              damageType: DamageType.CRUSHING,
              modifier: -1,
            ),
            minimumSt: 10,
            price: 0,
            weight: 0,
            reach: HandWeaponReach(
              maxReach: 1,
            ),
            notes:
                'A kick with a leg, be carefull and do not fall in the process though',
            lc: LegalityClass.OPEN,
          ),
        ],
        possessions: [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'points': points,
        'personal_info': personalInfo.toJson,
        'attributes': attributes.toJson,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'traits': List<dynamic>.from(traits.map((x) => x)),
        'spells': List<dynamic>.from(spells.map((x) => x)),
      };
}
