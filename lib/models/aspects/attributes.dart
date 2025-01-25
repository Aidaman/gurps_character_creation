enum Attributes {
  ST,
  DX,
  IQ,
  HT,
  Per,
  Will,
  HP,
  FP,
  BASIC_SPEED,
  BASIC_MOVE,
  NONE
}

extension AttributeAdjustments on Attributes {
  int get adjustPriceOf => switch (this) {
        Attributes.ST => 10,
        Attributes.DX => 20,
        Attributes.IQ => 20,
        Attributes.HT => 10,
        Attributes.Per => 5,
        Attributes.Will => 5,
        Attributes.HP => 2,
        Attributes.FP => 3,
        Attributes.BASIC_SPEED => 5,
        Attributes.BASIC_MOVE => 5,
        Attributes.NONE => 0,
      };

  double get adjustValueOf => switch (this) {
        Attributes.ST => 1,
        Attributes.DX => 1,
        Attributes.IQ => 1,
        Attributes.HT => 1,
        Attributes.Per => 1,
        Attributes.Will => 1,
        Attributes.HP => 1,
        Attributes.FP => 1,
        Attributes.BASIC_SPEED => 0.25,
        Attributes.BASIC_MOVE => 1,
        Attributes.NONE => 0,
      };
}

extension AttributesExtension on Attributes {
  String get stringValue => switch (this) {
        Attributes.ST => 'Strength',
        Attributes.DX => 'Dexterity',
        Attributes.IQ => 'IQ',
        Attributes.HT => 'Health',
        Attributes.Per => 'Perception',
        Attributes.Will => 'Will',
        Attributes.HP => 'Hit Points',
        Attributes.FP => 'Fatigue Points',
        Attributes.BASIC_SPEED => 'Basic Speed',
        Attributes.BASIC_MOVE => 'Basic Move',
        Attributes.NONE => 'None',
      };

  String get abbreviatedStringValue => switch (this) {
        Attributes.ST => 'ST',
        Attributes.DX => 'DX',
        Attributes.IQ => 'IQ',
        Attributes.HT => 'HT',
        Attributes.Per => 'Per',
        Attributes.Will => 'Will',
        Attributes.HP => 'HP',
        Attributes.FP => 'FP',
        Attributes.BASIC_SPEED => 'Speed',
        Attributes.BASIC_MOVE => 'Move',
        Attributes.NONE => 'None',
      };

  static List<Attributes> get primaryAttributes => [
        Attributes.ST,
        Attributes.DX,
        Attributes.IQ,
        Attributes.HT,
      ];

  static List<Attributes> get derivedAttributes => [
        Attributes.HP,
        Attributes.Will,
        Attributes.Per,
        Attributes.FP,
        Attributes.BASIC_MOVE,
        Attributes.BASIC_SPEED,
      ];

  static Attributes? fromString(String stat) {
    return switch (stat.toLowerCase()) {
      'st' => Attributes.ST,
      'dx' => Attributes.DX,
      'iq' => Attributes.IQ,
      'ht' => Attributes.HT,
      'per' => Attributes.Per,
      'will' => Attributes.Will,
      'hp' => Attributes.HP,
      'fp' => Attributes.FP,
      'speed' => Attributes.BASIC_SPEED,
      'move' => Attributes.BASIC_MOVE,
      _ => Attributes.NONE
    };
  }
}
