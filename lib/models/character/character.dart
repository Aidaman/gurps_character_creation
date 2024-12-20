import 'package:gurps_character_creation/models/characteristics/attributes.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/characteristics/spells/spell.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
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

  String name;
  String avatarURL;
  String playerName;
  String appearanceDetails;

  int height;
  int weight;
  int age;
  int sizeModifier;

  int strength;
  int iq;
  int dexterity;
  int health;

  List<Skill> skills;
  List<Trait> traits;
  List<Spell> spells;

  List<Weapon> weapons;
  List<Armor> armor;
  List<Posession> possessions;

  static const int MIN_PRIMARY_ATTRIBUTE_VALUE = 1;
  static const int MAX_PRIMARY_ATTRIBUTE_VALUE = 20;
  static const int DEFAULT_PRIMARY_ATTRIBUTE_VALUE = 10;

  // Calculated characteristics
  int get hitPoints =>
      strength + sizeModifier + pointsSpentOnHP ~/ Attributes.HP.adjustPriceOf;
  int pointsSpentOnHP = 0;

  int get will => iq + pointsSpentOnWill ~/ Attributes.Will.adjustPriceOf;
  int pointsSpentOnWill = 0;

  int get perception => iq + pointsSpentOnPer ~/ Attributes.Per.adjustPriceOf;
  int pointsSpentOnPer = 0;

  double get basicSpeed =>
      ((health + dexterity) / 4) +
      (pointsSpentOnBS / Attributes.BASIC_SPEED.adjustPriceOf);
  int pointsSpentOnBS = 0;

  int get basicMove =>
      ((basicSpeed - (basicSpeed % 1)).toInt()) +
      pointsSpentOnBM ~/ Attributes.BASIC_MOVE.adjustPriceOf;
  int pointsSpentOnBM = 0;

  int get fatiguePoints =>
      health + pointsSpentOnFP ~/ Attributes.FP.adjustPriceOf;
  int pointsSpentOnFP = 0;

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
      (sum, attr) => sum + getPointsSpentOnAttribute(attr),
    );

    return points - total;
  }

  Character({
    required this.gameId,
    required this.name,
    required this.avatarURL,
    required this.playerName,
    required this.appearanceDetails,
    required this.height,
    required this.weight,
    required this.age,
    required this.points,
    required this.sizeModifier,
    required this.strength,
    required this.iq,
    required this.dexterity,
    required this.health,
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
    required this.name,
    required this.avatarURL,
    required this.playerName,
    required this.appearanceDetails,
    required this.height,
    required this.weight,
    required this.age,
    required this.points,
    required this.sizeModifier,
    required this.strength,
    required this.iq,
    required this.dexterity,
    required this.health,
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
        strength: json['strength'],
        dexterity: json['dexterity'],
        iq: json['iq'],
        health: json['health'],
        height: json['height'],
        weight: json['weight'],
        age: json['age'],
        points: json['po  ints'],
        sizeModifier: json['sizeModifier'],
        name: json['name'],
        avatarURL: json['avatarURL'],
        playerName: json['playerName'],
        appearanceDetails: json['appearanceDetails'],
        skills: List<Skill>.from(json['skills'].map((x) => x)),
        traits: List<Trait>.from(json['traits'].map((x) => x)),
        spells: List<Spell>.from(json['spells'].map((x) => x)),
        weapons: List<Weapon>.from(json['weapons'].map((x) => x)),
        armor: List<Armor>.from(json['armor'].map((x) => x)),
        possessions: List<Posession>.from(json['possessions'].map((x) => x)),
      );

  factory Character.empty() => Character(
        gameId: 'random',
        name: 'name',
        avatarURL: '',
        playerName: 'player\'s name',
        appearanceDetails: 'appearance details',
        height: 0,
        age: 0,
        points: 100,
        sizeModifier: 0,
        strength: 10,
        iq: 10,
        dexterity: 10,
        health: 10,
        skills: [],
        traits: [],
        spells: [],
        weight: 0,
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
            reach: const HandWeaponReach(
              minimalRange: 0,
              maximumRange: 0,
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
            reach: const HandWeaponReach(
              minimalRange: 0,
              maximumRange: 0,
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
            reach: const HandWeaponReach(
              minimalRange: 0,
              maximumRange: 0,
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
        'strength': strength,
        'dexterity': dexterity,
        'iq': iq,
        'health': health,
        'height': height,
        'weight': weight,
        'age': age,
        'points': points,
        'sizeModifier': sizeModifier,
        'name': name,
        'avatarURL': avatarURL,
        'playerName': playerName,
        'appearanceDetails': appearanceDetails,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'traits': List<dynamic>.from(traits.map((x) => x)),
        'spells': List<dynamic>.from(spells.map((x) => x)),
      };

  double adjustPrimaryAttribute(Attributes stat, double newValue) {
    int attributeValue = getAttribute(stat);

    if (newValue <= MIN_PRIMARY_ATTRIBUTE_VALUE) {
      return MIN_PRIMARY_ATTRIBUTE_VALUE.toDouble();
    }

    if (newValue >= MAX_PRIMARY_ATTRIBUTE_VALUE) {
      return MAX_PRIMARY_ATTRIBUTE_VALUE.toDouble();
    }

    if (attributeValue > newValue) {
      return newValue;
    }

    if (remainingPoints < stat.adjustPriceOf) {
      return attributeValue.toDouble();
    }

    return newValue;
  }

  double adjustDerivedAttribute(Attributes stat, double newValue) {
    int attributeValue = getPointsSpentOnAttribute(stat);

    if (remainingPoints < stat.adjustPriceOf) {
      return attributeValue.toDouble();
    }

    return newValue;
  }

  int getPointsSpentOnAttribute(Attributes attribute) {
    switch (attribute) {
      case Attributes.ST:
        return (getAttribute(attribute) - DEFAULT_PRIMARY_ATTRIBUTE_VALUE) *
            Attributes.ST.adjustPriceOf;
      case Attributes.DX:
        return (getAttribute(attribute) - DEFAULT_PRIMARY_ATTRIBUTE_VALUE) *
            Attributes.DX.adjustPriceOf;
      case Attributes.IQ:
        return (getAttribute(attribute) - DEFAULT_PRIMARY_ATTRIBUTE_VALUE) *
            Attributes.IQ.adjustPriceOf;
      case Attributes.HT:
        return (getAttribute(attribute) - DEFAULT_PRIMARY_ATTRIBUTE_VALUE) *
            Attributes.HT.adjustPriceOf;
      case Attributes.Per:
        return pointsSpentOnPer;
      case Attributes.Will:
        return pointsSpentOnWill;
      case Attributes.HP:
        return pointsSpentOnHP;
      case Attributes.FP:
        return pointsSpentOnFP;
      case Attributes.BASIC_SPEED:
        return pointsSpentOnBS;
      case Attributes.BASIC_MOVE:
        return pointsSpentOnBM;
      case Attributes.NONE:
        return 0;
    }
  }

  int getAttribute(Attributes attribute) {
    switch (attribute) {
      case Attributes.ST:
        return strength;
      case Attributes.DX:
        return dexterity;
      case Attributes.IQ:
        return iq;
      case Attributes.HT:
        return health;
      case Attributes.Per:
        return perception;
      case Attributes.Will:
        return will;
      case Attributes.HP:
        return hitPoints;
      case Attributes.FP:
        return fatiguePoints;
      case Attributes.BASIC_SPEED:
        return basicSpeed.toInt();
      case Attributes.BASIC_MOVE:
        return basicMove;
      case Attributes.NONE:
        return -1;
    }
  }
}
