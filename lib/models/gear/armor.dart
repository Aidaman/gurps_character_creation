import 'package:gurps_character_creation/models/gear/gear.dart';

enum BodyPart {
  HEAD,
  SKULL,
  FACE,
  NECK,
  TORSO,
  CHEST,
  ABDOMEN,
  GROIN,
  ARMS,
  SHOULDERS,
  UPPER_ARMS,
  ELBOWS,
  FOREARMS,
  HANDS,
  LEGS,
  THIGS,
  KNEES,
  SHINS,
  FEET,
  NONE,
}

extension BodyPartString on BodyPart {
  String get stringValue => switch (this) {
        BodyPart.HEAD => 'Head',
        BodyPart.SKULL => 'Skull',
        BodyPart.FACE => 'Face',
        BodyPart.NECK => 'Neck',
        BodyPart.TORSO => 'Torso',
        BodyPart.CHEST => 'Chest',
        BodyPart.ABDOMEN => 'Abdomen',
        BodyPart.GROIN => 'Groin',
        BodyPart.ARMS => 'Arms',
        BodyPart.SHOULDERS => 'Shoulders',
        BodyPart.UPPER_ARMS => 'Upper Arms',
        BodyPart.ELBOWS => 'Elbows',
        BodyPart.FOREARMS => 'Forearms',
        BodyPart.HANDS => 'Hands',
        BodyPart.LEGS => 'Legs',
        BodyPart.THIGS => 'Thigs',
        BodyPart.KNEES => 'Knees',
        BodyPart.SHINS => 'Shins',
        BodyPart.FEET => 'Fees',
        BodyPart.NONE => 'NONE',
      };

  static BodyPart fromString(String stringValue) =>
      switch (stringValue.toLowerCase()) {
        'head' => BodyPart.HEAD,
        'skull' => BodyPart.SKULL,
        'face' => BodyPart.FACE,
        'neck' => BodyPart.NECK,
        'torso' => BodyPart.TORSO,
        'chest' => BodyPart.CHEST,
        'abdomen' => BodyPart.ABDOMEN,
        'groin' => BodyPart.GROIN,
        'arms' => BodyPart.ARMS,
        'shoulders' => BodyPart.SHOULDERS,
        'upper arms' => BodyPart.UPPER_ARMS,
        'elbows' => BodyPart.ELBOWS,
        'forearms' => BodyPart.FOREARMS,
        'hands' => BodyPart.HANDS,
        'legs' => BodyPart.LEGS,
        'thigs' => BodyPart.THIGS,
        'knees' => BodyPart.KNEES,
        'shins' => BodyPart.SHINS,
        'fees' => BodyPart.FEET,
        String() => BodyPart.NONE
      };
}

class ArmorLocation {
  final BodyPart bodyPart;
  double _covearage;

  ArmorLocation({required this.bodyPart, required double covearage})
      : _covearage = covearage;

  double get covearage => _covearage;
  set covearage(double value) {
    if (value > 100 || value < 0) {
      return;
    }

    _covearage = value;
  }

  @override
  String toString() {
    if (covearage == 100) {
      return '$bodyPart';
    }

    return '$bodyPart $covearage%';
  }
}

class Armor extends Gear {
  final ArmorLocation armorLocation;
  final bool? flexibility;
  final bool? isLayerable;
  int _passiveDefense;
  int _damageResistance;
  String? notes;

  int get passiveDefense => _passiveDefense;
  set passiveDefense(int value) {
    if (value > 0) {
      _passiveDefense = value;
    }
  }

  int get damageResistance => _damageResistance;
  set damageResistance(int value) {
    if (value >= 0) {
      _damageResistance = value;
    }
  }

  Armor({
    required super.name,
    required super.price,
    required super.weight,
    required this.armorLocation,
    required this.flexibility,
    required this.isLayerable,
    required int passiveDefense,
    required int damageResistance,
    this.notes,
  })  : _passiveDefense = passiveDefense,
        _damageResistance = damageResistance;
}
