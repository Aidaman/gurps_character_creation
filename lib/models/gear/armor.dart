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

  static bool isDamageResistance(Map<String, dynamic> map) =>
      map.containsKey('damage_resistance');

  factory DamageResistance.fromJson(Map<String, dynamic> json) =>
      DamageResistance(
        resistance: int.parse(json['damage_resistance'].toString()),
        denominatorResistance: json['denominator_resistance'] != null
            ? int.parse(json['denominator_resistance'].toString())
            : null,
        isFlexible: bool.parse(json['is_flexible'].toString()),
        isFrontOnly: bool.parse(json['is_front_only'].toString()),
      );

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

  Map<String, dynamic> toJson() => {
        'damage_resistance': damageResistance,
        'denominator_resistance': denominatorResistance,
        'is_flexible': isFlexible,
        'is_front_only': isFrontOnly,
      };

  // ignore: non_constant_identifier_names
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
  final String? notes;
  final DamageResistance damageResistance;

  Armor({
    required super.name,
    required super.price,
    required super.weight,
    required this.armorLocation,
    required this.damageResistance,
    this.notes,
  });

  Armor.withId({
    required super.name,
    required super.price,
    required super.weight,
    required super.id,
    required this.armorLocation,
    required this.damageResistance,
    this.notes,
  }) : super.withId();

  factory Armor.copyWith(
    Armor armor, {
    String? name,
    double? price,
    double? weight,
    String? id,
    BodyPart? armorLocation,
    DamageResistance? damageResistance,
    String? notes,
  }) =>
      Armor.withId(
        id: armor.id,
        name: name ?? armor.name,
        price: price ?? armor.price,
        weight: weight ?? armor.weight,
        armorLocation: armorLocation ?? armor.armorLocation,
        damageResistance: damageResistance ?? armor.damageResistance,
      );

  factory Armor.empty() => Armor(
        name: '',
        price: 0,
        weight: 0,
        armorLocation: BodyPart.TORSO,
        damageResistance: DamageResistance(resistance: 0),
      );

  factory Armor.fromJson(Map<String, dynamic> json) => Armor(
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        armorLocation: BodyPartString.fromString(json['armor_location']),
        damageResistance: DamageResistance.fromJson(json['damage_resistance']),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'armor_location': armorLocation.stringValue,
        'damage_resistance': damageResistance.toJson(),
      };

  Map<String, dynamic> get dataTableColumns => {
        'name': name,
        'price': price,
        'weight': weight,
        'armor_location': armorLocation.stringValue,
        'damage_resistance': damageResistance.toJson(),
      };
}
