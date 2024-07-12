import 'package:gurps_character_creation/models/traits/advantage.dart';
import 'package:gurps_character_creation/models/traits/disadvantage.dart';
import 'package:gurps_character_creation/models/traits/skills/magic_spell.dart';
import 'package:gurps_character_creation/models/traits/skills/skill.dart';
import 'package:gurps_character_creation/models/traits/skills/skill_stat.dart';
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

  List<Advantage> advantages;
  List<Disadvantage> disadvantages;
  List<Skill> skills;
  List<MagicSpell> magicSpells;

  // Calculated characteristics
  int get hitPoints => strength + sizeModifier;
  int get will => iq;
  int get perception => iq;
  double get basicSpeed => (health + dexterity) / 4;
  int get basicMove => (basicSpeed - (basicSpeed % 1)).toInt();

  int get remainingPoints {
    int totalCount = [
      ...advantages,
      ...disadvantages,
      ...skills,
      ...magicSpells,
    ].map((Trait t) => t.cost).reduce((sum, cost) => sum + cost);

    return points - totalCount;
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
    required this.advantages,
    required this.disadvantages,
    required this.skills,
    required this.magicSpells,
  });

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json["id"],
        gameId: json["gameId"],
        strength: json["strength"],
        dexterity: json["dexterity"],
        iq: json["iq"],
        health: json["health"],
        height: json["height"],
        age: json["age"],
        points: json["points"],
        maxDisadvantages: json["maxDisadvantages"],
        sizeModifier: json["sizeModifier"],
        fatiguePoints: json["fatiguePoints"],
        name: json["name"],
        avatarURL: json["avatarURL"],
        playerName: json["playerName"],
        religion: json["religion"],
        appearanceDetails: json["appearanceDetails"],
        advantages: List<Advantage>.from(json["advantages"].map((x) => x)),
        disadvantages:
            List<Disadvantage>.from(json["disadvantages"].map((x) => x)),
        skills: List<Skill>.from(json["skills"].map((x) => x)),
        magicSpells: List<MagicSpell>.from(json["magicSpells"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gameId": gameId,
        "strength": strength,
        "dexterity": dexterity,
        "iq": iq,
        "health": health,
        "height": height,
        "age": age,
        "points": points,
        "maxDisadvantages": maxDisadvantages,
        "sizeModifier": sizeModifier,
        "fatiguePoints": fatiguePoints,
        "name": name,
        "avatarURL": avatarURL,
        "playerName": playerName,
        "religion": religion,
        "appearanceDetails": appearanceDetails,
        "advantages": List<dynamic>.from(advantages.map((x) => x)),
        "disadvantages": List<dynamic>.from(disadvantages.map((x) => x)),
        "skills": List<dynamic>.from(skills.map((x) => x)),
        "magicSpells": List<dynamic>.from(magicSpells.map((x) => x)),
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
    }
  }
}
