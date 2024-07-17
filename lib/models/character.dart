// import 'package:gurps_character_creation/models/traits/advantage.dart';
// import 'package:gurps_character_creation/models/traits/disadvantage.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_stat.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';

class Character {
  int id;
  int gameId;
  int points;
  int maxDisadvantages;

  String name;
  String avatarURL;
  String playerName;
  String religion;
  String appearanceDetails;

  int height;
  int age;
  int sizeModifier;
  int fatiguePoints;

  int strength;
  int iq;
  int dexterity;
  int health;

  List<Skill> skills;
  List<Trait> traits;

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
        .reduce(
          (sum, cost) => sum + cost,
        );
    int skillsTotalCount = skills
        .map(
          (Skill s) => s.basePoints + s.investedPoints,
        )
        .reduce(
          (sum, cost) => sum + cost,
        );

    return points - (traitsTotalCount + skillsTotalCount);
  }

  Character({
    required this.id,
    required this.gameId,
    required this.name,
    required this.avatarURL,
    required this.playerName,
    required this.religion,
    required this.appearanceDetails,
    required this.height,
    required this.age,
    required this.points,
    required this.maxDisadvantages,
    required this.sizeModifier,
    required this.fatiguePoints,
    required this.strength,
    required this.iq,
    required this.dexterity,
    required this.health,
    required this.skills,
    required this.traits,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json['id'],
        gameId: json['gameId'],
        strength: json['strength'],
        dexterity: json['dexterity'],
        iq: json['iq'],
        health: json['health'],
        height: json['height'],
        age: json['age'],
        points: json['points'],
        maxDisadvantages: json['maxDisadvantages'],
        sizeModifier: json['sizeModifier'],
        fatiguePoints: json['fatiguePoints'],
        name: json['name'],
        avatarURL: json['avatarURL'],
        playerName: json['playerName'],
        religion: json['religion'],
        appearanceDetails: json['appearanceDetails'],
        skills: List<Skill>.from(json['skills'].map((x) => x)),
        traits: List<Trait>.from(json['traits'].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'strength': strength,
        'dexterity': dexterity,
        'iq': iq,
        'health': health,
        'height': height,
        'age': age,
        'points': points,
        'maxDisadvantages': maxDisadvantages,
        'sizeModifier': sizeModifier,
        'fatiguePoints': fatiguePoints,
        'name': name,
        'avatarURL': avatarURL,
        'playerName': playerName,
        'religion': religion,
        'appearanceDetails': appearanceDetails,
        'skills': List<dynamic>.from(skills.map((x) => x)),
        'traits': List<dynamic>.from(traits.map((x) => x)),
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
    }
  }
}
