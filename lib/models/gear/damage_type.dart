enum DamageType {
  CUTTING,
  CRUSHING,
  IMPALING,
  PIERCING,
  PIERCING_LARGE,
  PIERCING_SMALL,
  BURNING,
  TOXIC,
  CORROSIVE,
  FATIGUE,
  NONE,
}

extension DamageTypeString on DamageType {
  static final Map<String, DamageType> _stringToDamageTypeMap = {
    'cut': DamageType.CUTTING,
    'cutting': DamageType.CUTTING,
    'cr': DamageType.CRUSHING,
    'crushing': DamageType.CRUSHING,
    'imp': DamageType.IMPALING,
    'impaling': DamageType.IMPALING,
    'pi': DamageType.PIERCING,
    'piercing': DamageType.PIERCING,
    'pi+': DamageType.PIERCING_LARGE,
    'large piercing': DamageType.PIERCING_LARGE,
    'pi-': DamageType.PIERCING_SMALL,
    'small piercing': DamageType.PIERCING_SMALL,
    'burn': DamageType.BURNING,
    'burning': DamageType.BURNING,
    'tox': DamageType.TOXIC,
    'toxic': DamageType.TOXIC,
    'cor': DamageType.CORROSIVE,
    'corrosive': DamageType.CORROSIVE,
    'fatigue': DamageType.FATIGUE,
  };

  String get abbreviatedStringValue => switch (this) {
        DamageType.CUTTING => 'cut',
        DamageType.CRUSHING => 'cr',
        DamageType.IMPALING => 'imp',
        DamageType.PIERCING => 'pi',
        DamageType.PIERCING_LARGE => 'pi+',
        DamageType.PIERCING_SMALL => 'pi-',
        DamageType.BURNING => 'burn',
        DamageType.TOXIC => 'tox',
        DamageType.CORROSIVE => 'cor',
        DamageType.FATIGUE => 'fatigue',
        DamageType.NONE => '',
      };

  String get stringValue => switch (this) {
        DamageType.CUTTING => 'Cutting',
        DamageType.CRUSHING => 'Crushing',
        DamageType.IMPALING => 'Impaling',
        DamageType.PIERCING => 'Piercing',
        DamageType.PIERCING_LARGE => 'Large Piercing',
        DamageType.PIERCING_SMALL => 'Small Piercing',
        DamageType.BURNING => 'Burning',
        DamageType.TOXIC => 'Toxic',
        DamageType.CORROSIVE => 'Corrosive',
        DamageType.FATIGUE => 'fatigue',
        DamageType.NONE => '',
      };

  DamageType fromString(String type) {
    return _stringToDamageTypeMap[type.toLowerCase()] ?? DamageType.NONE;
  }
}
