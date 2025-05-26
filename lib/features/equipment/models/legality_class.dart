enum LegalityClass {
  BANNED,
  MILITARY,
  RESTRICTED,
  LICENSED,
  OPEN,
  NONE,
}

extension LegalityClassExtention on LegalityClass {
  String get stringValue => switch (this) {
        LegalityClass.BANNED => 'Banned',
        LegalityClass.MILITARY => 'Military',
        LegalityClass.RESTRICTED => 'Restricted',
        LegalityClass.LICENSED => 'Licensed',
        LegalityClass.OPEN => 'Open',
        LegalityClass.NONE => 'NONE',
      };

  String get abbreviatedStringValue => switch (this) {
        LegalityClass.BANNED => 'LC0',
        LegalityClass.MILITARY => 'LC1',
        LegalityClass.RESTRICTED => 'LC2',
        LegalityClass.LICENSED => 'LC3',
        LegalityClass.OPEN => 'LC4',
        LegalityClass.NONE => 'NONE',
      };

  static LegalityClass fromString(String string) =>
      switch (string.toLowerCase()) {
        'banned' => LegalityClass.BANNED,
        '0' => LegalityClass.BANNED,
        'lc0' => LegalityClass.BANNED,
        'military' => LegalityClass.MILITARY,
        '1' => LegalityClass.MILITARY,
        'lc1' => LegalityClass.MILITARY,
        'restricted' => LegalityClass.RESTRICTED,
        '2' => LegalityClass.RESTRICTED,
        'lc2' => LegalityClass.RESTRICTED,
        'licensed' => LegalityClass.LICENSED,
        '3' => LegalityClass.LICENSED,
        'lc3' => LegalityClass.LICENSED,
        'open' => LegalityClass.OPEN,
        '4' => LegalityClass.OPEN,
        'lc4' => LegalityClass.OPEN,
        String() => LegalityClass.NONE,
      };
}
