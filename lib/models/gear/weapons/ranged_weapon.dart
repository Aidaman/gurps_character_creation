import 'package:gurps_character_creation/models/gear/legality_class.dart';
import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';

class RangeWeaponShots {
  final int shotsAvailable;
  final int? reloadsBeforeCompleteReload;

  const RangeWeaponShots({
    required this.shotsAvailable,
    this.reloadsBeforeCompleteReload,
  });

  factory RangeWeaponShots.fromJson(Map<String, dynamic> json) =>
      RangeWeaponShots(
        shotsAvailable: json['shots_available'],
        reloadsBeforeCompleteReload: json['reloads_before_complete_reload'],
      );

  static isShots(Map<String, dynamic> json) =>
      json.containsKey('shots_available');

  Map<String, dynamic> toJson() => {
        'shots_available': shotsAvailable,
        'reloads_before_complete_reload': reloadsBeforeCompleteReload ?? 0
      };

  @override
  String toString() {
    if (reloadsBeforeCompleteReload != null) {
      return '$shotsAvailable (${reloadsBeforeCompleteReload!})';
    }

    return '$shotsAvailable';
  }
}

class WeaponStrengths {
  int strengthValue;
  bool? isTwoHanded;
  bool? hasBonusForHigherStrength;

  WeaponStrengths({
    required this.strengthValue,
    this.isTwoHanded,
    this.hasBonusForHigherStrength,
  });

  factory WeaponStrengths.fromJson(Map<String, dynamic> json) =>
      WeaponStrengths(
        strengthValue: json['strength_value'],
        hasBonusForHigherStrength:
            json['has_bonus_for_higher_strength'] ?? false,
        isTwoHanded: json['is_two_handed'] ?? false,
      );

  static bool isWeaponStrengths(Map<String, dynamic> json) =>
      json.containsKey('strength_value');

  Map<String, dynamic> toJson() => {
        'strength_value': strengthValue,
        'has_bonus_for_higher_strength': hasBonusForHigherStrength ?? false,
        'is_two_handed': isTwoHanded ?? false,
      };

  @override
  String toString() {
    String result = strengthValue.toString();

    if (hasBonusForHigherStrength == true) {
      result += '+';
    }

    if (isTwoHanded == true) {
      result += '†';
    }

    return result;
  }
}

class Range {
  int? _minRange;
  int? get minRange => _minRange;
  set minRange(int? value) {
    if (value == null) {
      return;
    }

    if (maxRange == 0) {
      maxRange = value;
      return;
    }

    if (maxRange < value) {
      _minRange = maxRange;
      maxRange = value;
      return;
    }

    _minRange = value;
  }

  int maxRange;

  Range({int? minRange, required this.maxRange}) : _minRange = minRange;

  factory Range.fromJson(Map<String, dynamic> json) => Range(
        minRange: json['min_range'] ?? 0,
        maxRange: json['max_range'],
      );

  static isRange(Map<String, dynamic> json) => json.containsKey('min_range');

  Map<String, dynamic> toJson() => {
        'min_range': minRange ?? 0,
        'max_range': maxRange,
      };

  @override
  String toString() {
    if (minRange != null) {
      return '$minRange/$maxRange';
    }

    return '$maxRange';
  }
}

class RangedWeapon extends Weapon {
  final Range range;
  final int accuracy;
  final int rateOfFire;
  final RangeWeaponShots shots;
  final int bulk;
  final int recoil;
  final WeaponStrengths st;

  RangedWeapon({
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required this.range,
    required this.accuracy,
    required this.rateOfFire,
    required this.shots,
    required this.bulk,
    required this.recoil,
    required this.st,
    required super.lc,
    required super.minimumSt,
  });

  RangedWeapon.withId({
    required super.damage,
    required super.notes,
    required super.name,
    required super.price,
    required super.weight,
    required super.associatedSkillName,
    required super.minimumSt,
    required this.range,
    required this.accuracy,
    required this.rateOfFire,
    required this.shots,
    required this.bulk,
    required this.recoil,
    required this.st,
    required super.lc,
    required super.id,
  }) : super.withId();

  factory RangedWeapon.copyWith(
    RangedWeapon rw, {
    WeaponDamage? damage,
    String? notes,
    String? name,
    double? price,
    double? weight,
    String? associatedSkillName,
    int? minimumSt,
    Range? range,
    int? accuracy,
    int? rateOfFire,
    RangeWeaponShots? shots,
    int? bulk,
    int? recoil,
    WeaponStrengths? st,
    LegalityClass? lc,
  }) {
    return RangedWeapon.withId(
      id: rw.id,
      damage: damage ?? rw.damage,
      notes: notes ?? rw.notes,
      name: name ?? rw.name,
      price: price ?? rw.price,
      weight: weight ?? rw.weight,
      associatedSkillName: associatedSkillName ?? rw.associatedSkillName,
      minimumSt: minimumSt ?? rw.minimumSt,
      range: range ?? rw.range,
      accuracy: accuracy ?? rw.accuracy,
      rateOfFire: rateOfFire ?? rw.rateOfFire,
      shots: shots ?? rw.shots,
      bulk: bulk ?? rw.bulk,
      recoil: recoil ?? rw.recoil,
      st: st ?? rw.st,
      lc: lc ?? rw.lc,
    );
  }

  factory RangedWeapon.empty() => RangedWeapon(
        damage: WeaponDamage(
          attackType: AttackTypes.THRUST,
          modifier: 0,
          damageType: DamageType.NONE,
        ),
        notes: '',
        name: '',
        price: 0,
        weight: 0,
        range: Range(minRange: 0, maxRange: 0),
        accuracy: 0,
        rateOfFire: 0,
        shots: const RangeWeaponShots(
          shotsAvailable: 0,
          reloadsBeforeCompleteReload: 0,
        ),
        bulk: 0,
        recoil: 0,
        st: WeaponStrengths(
          strengthValue: 0,
          hasBonusForHigherStrength: false,
          isTwoHanded: false,
        ),
        lc: LegalityClass.NONE,
        associatedSkillName: '',
        minimumSt: 10,
      );

  factory RangedWeapon.fromJson(Map<String, dynamic> json) => RangedWeapon(
        damage: WeaponDamage.fromJson(json['damage']),
        notes: json['notes'],
        name: json['name'],
        price: json['price'],
        weight: json['weight'],
        associatedSkillName: json['associatedSkillName'],
        range: json['range'],
        accuracy: json['accuracy'],
        rateOfFire: json['rateOfFire'],
        shots: RangeWeaponShots.fromJson(json['shots']),
        bulk: json['bulk'],
        recoil: json['recoil'],
        st: WeaponStrengths.fromJson(json['st']),
        lc: LegalityClassExtention.fromString(json['lc']),
        minimumSt: json['minimumSt'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'weight': weight,
        'notes': notes,
        'accuracy': accuracy,
        'rate_of_fire': rateOfFire,
        'bulk': bulk,
        'recoil': recoil,
        'range': range.toJson(),
        'shots': shots.toJson(),
        'st': st.toJson(),
        'lc': lc.stringValue,
      };

  Map<String, dynamic> toDataTableColumns() => {
        'name': name,
        'price': price,
        'weight': weight,
        'accuracy': accuracy,
        'ROF': rateOfFire,
        'recoil': recoil,
        'range': range.toJson(),
        'shots': shots.toJson(),
        'st': st.toJson(),
      };
}
