import 'package:gurps_character_creation/models/gear/gear.dart';

enum BodyPart {
  HEAD,
  SKULL,
  EYES,
  FACE,
  TORSO,
  NECK,
  GROIN,
  ARMS,
  HANDS,
  LEGS,
  FEET,
  NONE,
}

extension BodyPartString on BodyPart {
  String get stringValue => switch (this) {
        BodyPart.HEAD => 'Head',
        BodyPart.SKULL => 'Skull',
        BodyPart.FACE => 'Face',
        BodyPart.EYES => 'Eyes',
        BodyPart.NECK => 'Neck',
        BodyPart.TORSO => 'Torso',
        BodyPart.GROIN => 'Groin',
        BodyPart.ARMS => 'Arms',
        BodyPart.HANDS => 'Hands',
        BodyPart.LEGS => 'Legs',
        BodyPart.FEET => 'Fees',
        BodyPart.NONE => 'NONE',
      };

  static BodyPart fromString(String stringValue) =>
      switch (stringValue.toLowerCase()) {
        'head' => BodyPart.HEAD,
        'skull' => BodyPart.SKULL,
        'face' => BodyPart.FACE,
        'eyes' => BodyPart.EYES,
        'neck' => BodyPart.NECK,
        'torso' => BodyPart.TORSO,
        'groin' => BodyPart.GROIN,
        'arms' => BodyPart.ARMS,
        'hands' => BodyPart.HANDS,
        'legs' => BodyPart.LEGS,
        'fees' => BodyPart.FEET,
        String() => BodyPart.NONE
      };
}

class DamageResistance {
  final int damageResistance;
  final int? denominatorResistance;
  final bool isFlexible;
  final bool isFrontOnly;

  DamageResistance({
    required int resistance,
    this.denominatorResistance,
    bool? isFlexible,
    bool? isFrontOnly,
  })  : damageResistance = resistance >= 0 ? resistance : 1,
        isFlexible = isFlexible ?? false,
        isFrontOnly = isFrontOnly ?? false;

  factory DamageResistance.fromGURPSNotation(String notation) {
    String normalized = notation.toLowerCase();

    bool isFlexible = normalized.contains('*');

    bool isFrontOnly = normalized.contains('f');

    normalized = normalized.replaceAll('*', '').replaceAll('f', '');

    int resistance = 0;
    int? denominatorResistance;

    try {
      if (normalized.contains('/')) {
        List<String> fractions = normalized.split('/');
        resistance = int.parse(fractions[0]);
        denominatorResistance = int.parse(fractions[1]);
      } else {
        resistance = int.parse(normalized);
      }
    } catch (e) {
      throw FormatException('Incorrect GURPS notation: $notation');
    }

    return DamageResistance(
      resistance: resistance,
      denominatorResistance: denominatorResistance,
      isFlexible: isFlexible,
      isFrontOnly: isFrontOnly,
    );
  }

  String get GURPSNotation {
    String notation = '';

    if (denominatorResistance != null) {
      notation += '$damageResistance/$denominatorResistance';
    } else {
      notation += '$damageResistance';
    }

    if (isFrontOnly) {
      notation += 'f';
    }

    if (isFlexible) {
      notation += '*';
    }

    return notation;
  }
}

class Armor extends Gear {
  final BodyPart armorLocation;
  final bool? flexibility;
  final bool? isLayerable;
  final String? notes;
  final DamageResistance damageResistance;

  Armor({
    required super.name,
    required super.price,
    required super.weight,
    required this.armorLocation,
    required this.flexibility,
    required this.isLayerable,
    required this.damageResistance,
    this.notes,
  });
}
