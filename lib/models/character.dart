// import 'package:gurps_character_creation/models/traits/advantage.dart';
// import 'package:gurps_character_creation/models/traits/disadvantage.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_stat.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
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
  int fatiguePoints;

  int strength;
  int iq;
  int dexterity;
  int health;

  List<Skill> skills;
  List<Trait> traits;
  List<Spell> spells;

  // Calculated characteristics
  int get hitPoints => strength + sizeModifier;
  int get will => iq;
  int get perception => iq;
  double get basicSpeed => (health + dexterity) / 4;
  int get basicMove => (basicSpeed - (basicSpeed % 1)).toInt();

  int get remainingPoints {
    int traitsTotalCount = traits
        .map(
          (Trait t) => t.basePoints,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );
    int skillsTotalCount = skills
        .map(
          (Skill s) => s.basePoints + s.investedPoints,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );
    int magicTotalCount = spells
        .map(
          (Spell s) => s.investedPoints,
        )
        .fold(
          0,
          (sum, cost) => sum + cost,
        );

    return points - (traitsTotalCount + skillsTotalCount + magicTotalCount);
  }

  Character({
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
    required this.fatiguePoints,
    required this.strength,
    required this.iq,
    required this.dexterity,
    required this.health,
    required this.skills,
    required this.traits,
    required this.spells,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
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
        fatiguePoints: json['fatiguePoints'],
        name: json['name'],
        avatarURL: json['avatarURL'],
        playerName: json['playerName'],
        appearanceDetails: json['appearanceDetails'],
        skills: List<Skill>.from(json['skills'].map((x) => x)),
        traits: List<Trait>.from(json['traits'].map((x) => x)),
        spells: List<Spell>.from(json['spells'].map((x) => x)),
      );

  factory Character.empty() => Character(
        id: const Uuid().v4(),
        gameId: 'random',
        name: 'name',
        avatarURL: '',
        playerName: 'player\'s name',
        appearanceDetails: 'appearance details',
        height: 150,
        age: 21,
        points: 256,
        sizeModifier: 0,
        fatiguePoints: 10,
        strength: 10,
        iq: 10,
        dexterity: 10,
        health: 10,
        skills: [],
        traits: [],
        spells: [],
        weight: 60,
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
        'fatiguePoints': fatiguePoints,
        'name': name,
        'avatarURL': avatarURL,
        'playerName': playerName,
        'appearanceDetails': appearanceDetails,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'traits': List<dynamic>.from(traits.map((x) => x)),
        'spells': List<dynamic>.from(spells.map((x) => x)),
      };

  int getPrimaryAttribute(SkillStat stat) {
    switch (stat) {
      case SkillStat.ST:
        return strength;
      case SkillStat.DX:
        return dexterity;
      case SkillStat.IQ:
        return iq;
      case SkillStat.HT:
        return health;
      case SkillStat.Per:
        return perception;
      case SkillStat.Will:
        return will;
      case SkillStat.NONE:
        return -1;
    }
  }
}
