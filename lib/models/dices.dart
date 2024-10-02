enum Dices {
  D4,
  D6,
  D8,
  D10,
  D12,
  D20,
  D100,
  NONE,
}

extension DicesStrings on Dices {
  String get stringValue => switch (this) {
        Dices.D4 => 'd4',
        Dices.D6 => 'd6',
        Dices.D8 => 'd8',
        Dices.D10 => 'd10',
        Dices.D12 => 'd12',
        Dices.D20 => 'd20',
        Dices.D100 => 'd100',
        Dices.NONE => 'NONE',
      };

  static fromString(String string) => switch (string.toLowerCase()) {
        'd4' => Dices.D4,
        'd6' => Dices.D6,
        'd8' => Dices.D8,
        'd10' => Dices.D10,
        'd12' => Dices.D12,
        'd20' => Dices.D20,
        'd100' => Dices.D100,
        String() => Dices.NONE,
      };
}
