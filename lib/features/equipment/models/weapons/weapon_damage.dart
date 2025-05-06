import 'package:gurps_character_creation/features/equipment/models/weapons/damage_type.dart';

enum AttackTypes { THRUST, SWING, NONE }

extension AttackTypesString on AttackTypes {
  get stringValue => switch (this) {
        AttackTypes.THRUST => 'Thrust',
        AttackTypes.SWING => 'Swing',
        AttackTypes.NONE => 'NONE',
      };

  get abbreviatedStringValue => switch (this) {
        AttackTypes.THRUST => 'Thr',
        AttackTypes.SWING => 'Sw',
        AttackTypes.NONE => 'NONE',
      };

  static AttackTypes fromString(String str) => switch (str.toLowerCase()) {
        'thrust' => AttackTypes.THRUST,
        'thr' => AttackTypes.THRUST,
        'swing' => AttackTypes.SWING,
        'sw' => AttackTypes.SWING,
        String() => AttackTypes.NONE,
      };
}

class WeaponDamage {
  final AttackTypes attackType;
  final int modifier;
  final DamageType damageType;

  WeaponDamage({
    required this.attackType,
    required this.modifier,
    required this.damageType,
  });

  static bool isDamage(Map<String, dynamic> json) =>
      json.containsKey('attack_type');

  /*
    As for thrusting damage, I struggle to find any pattern there
    that could be resembled in well-outlined and simple formula

    It seems, however, that thrusting damage adds +1 dice every 9-10 ST

    While the modifier adds +1 every 2 ST
    
    But it is only when values more than 10, so I could
    Represent this like the following:
  */
  static int thrustingAttackDiceAmount(int characterST) {
    if (characterST <= 4) {
      return 0;
    }

    if (characterST > 4 && characterST < 19) {
      return 1;
    }

    /*
      For damage modifiers it is clear that the cycle is
      within range from -1 to +2 for 2 times each value, so 8 entries
      in total

      However, that means that we have to derive the dice, which is
      adding by the factor of 1 each cycle, from 9. 
      
      Why? 24 / 8 = 3, however the 24 ST for GURPS thrusting damage
      you throw 2d6+1. You should throw 3d6 after 27, and what is,
      kind of, confusing is that on 35 we have 4d6, not 36 and not 34
      so the step is something like 8.75
    */
    return characterST ~/ 8.75;
  }

  static int thrustingAttackModifier(int characterST, int? minST) {
    if (characterST < 4) {
      return 0;
    }

    int calculatedModifier = 0;

    if (characterST > 4 && characterST < 11) {
      calculatedModifier = switch (characterST) {
        5 => -5,
        6 => -4,
        7 => -3,
        8 => -3,
        9 => -2,
        10 => -2,
        int() => -0,
      };
    } else {
      /* 
        I observed a pattern that when the Character ST is more than 7
        the modifier is more or less defined as +1 for every 2 STs
        
        The thing starts at -1 and cycle ends at +2, so it gives us a 
        step of 8 since there is 4 possible values that repeats for 2
        times
        
        The cycle starts at 11 and ends up in the infinity

        Also the GURPS wiki with it's table had proven to me that this
        approach is kind of correct

        So, given that
      */
      calculatedModifier = switch (characterST % 8) {
        3 => -1,
        4 => -1,
        5 => 0,
        6 => 0,
        7 => 1,
        0 => 1,
        1 => 2,
        2 => 2,
        int() => 0,
      };
    }

    if (minST == null || characterST >= minST) {
      return calculatedModifier;
    }

    return calculatedModifier - (minST - characterST);
  }

  // Unlike the Thrusting damage it seems that there is a clearer pattern
  // After ST goes beyond 9 for swinging damage with this kind of formula
  // (x)dice - 1; (x+1)dice; (x+1)dice + 1; (x+1)dice + 2
  // So, basically: ((CharacterST - 9) % 4) - 1 for a modifier
  // And ((CharacterST - 9) ~/4) + 1 for a dice
  static int swingingAttackDiceAmount(int characterST) {
    if (characterST <= 4) {
      return 0;
    }

    if (characterST < 9) {
      return 1;
    }

    return ((characterST - 9) ~/ 4) + 1;
  }

  static int swingingAttackModifier(int characterST, int? minST) {
    if (characterST <= 4) {
      return 0;
    }

    /* 
      Apparently, when ST is more than 4 but less than 9 then
      There is a pattern as if it is calculated by adding the 
      ST to a negative 10:
      (-10 +) 8 => -2
      (-10 +) 7 => -3
      (-10 +) 6 => -4
      (-10 +) 5 => -5
    */
    const BASE_FOR_DAMAGE_MODIFIER_WHEN_ST_IS_BELOW_9 = -10;

    int calculatedModifier = characterST > 4 && characterST < 9
        ? BASE_FOR_DAMAGE_MODIFIER_WHEN_ST_IS_BELOW_9 + characterST
        : ((characterST - 9) % 4) - 1;

    if (minST == null || characterST >= minST) {
      return calculatedModifier;
    }

    return calculatedModifier - (minST - characterST);
  }

  /*
    While this damage calculation works good for 20 <= ST < 40, it 
    might requre some finer tuning after ST>40 or ST>50
    
    Though, it is not what I will do prematurely, since there is 
    no official formula, and it is too rare for players to have 
    their ST greater than 30 anyway. I already spent too much time
    on this than I had to
  */

  @override
  String toString() {
    if (modifier == 0) {
      return '${attackType.stringValue} ${damageType.abbreviatedStringValue}';
    }
    final String modifierSymbol = modifier > 0 ? '+' : '';

    return '${attackType.abbreviatedStringValue}$modifierSymbol$modifier ${damageType.abbreviatedStringValue}';
  }

  factory WeaponDamage.fromJson(Map<String, dynamic> json) => WeaponDamage(
        attackType: AttackTypesString.fromString(json['attack_type']),
        modifier: json['modifier'],
        damageType: DamageTypeString.fromString(json['damage_type']),
      );

  factory WeaponDamage.empty() => WeaponDamage(
        attackType: AttackTypes.NONE,
        modifier: 0,
        damageType: DamageType.NONE,
      );

  factory WeaponDamage.fromGURPSNotation(String notation) {
    final attackTypeRegex = RegExp(r'^(sw|thr)');
    final modifierRegex = RegExp(r'^(?:sw|thr)([+-]\d+)');

    final attackTypeMatch = attackTypeRegex.firstMatch(notation);
    final modifierMatch = modifierRegex.firstMatch(notation);

    if (attackTypeMatch == null) {
      throw Exception('Invalid GURPS notation: $notation');
    }

    final attackType = AttackTypesString.fromString(attackTypeMatch.group(0)!);
    notation = notation.replaceAll(attackTypeMatch.group(0)!, '');

    int modifier = 0;
    if (modifierMatch != null) {
      modifier = int.parse(modifierMatch.group(1)!);
    }

    // Remove the attack type and modifier from the notation
    notation = notation.replaceAll(attackTypeMatch.group(0)!, '');

    return WeaponDamage(
      attackType: attackType,
      modifier: modifier,
      damageType: DamageTypeString.fromString(notation.trim()),
    );
  }

  factory WeaponDamage.copyWith(
    WeaponDamage wd, {
    AttackTypes? attackType,
    int? modifier,
    DamageType? damageType,
  }) =>
      WeaponDamage(
        attackType: attackType ?? wd.attackType,
        modifier: modifier ?? wd.modifier,
        damageType: damageType ?? wd.damageType,
      );

  Map<String, dynamic> toJson() => {
        'attack_type': attackType.stringValue,
        'modifier': modifier,
        'damage_type': damageType.stringValue,
      };

  // Use character's ST to calculate the actual damage
  String calculateDamage(int characterST, int? minST) {
    int damageDice = switch (attackType) {
      AttackTypes.THRUST => thrustingAttackDiceAmount(characterST),
      AttackTypes.SWING => swingingAttackDiceAmount(characterST),
      AttackTypes.NONE => 0,
    };

    int damageModifier = switch (attackType) {
      AttackTypes.THRUST => thrustingAttackModifier(characterST, minST),
      AttackTypes.SWING => swingingAttackModifier(characterST, minST),
      AttackTypes.NONE => 0,
    };

    damageModifier += modifier;

    if (damageModifier == 0) {
      return '${damageDice}d6 ${damageType.abbreviatedStringValue}';
    }

    if (damageModifier > 0) {
      return '${damageDice}d6+$damageModifier ${damageType.abbreviatedStringValue}';
    }

    return '${damageDice}d6$damageModifier ${damageType.abbreviatedStringValue}';
  }
}
