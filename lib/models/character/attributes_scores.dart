import 'package:gurps_character_creation/models/aspects/attributes.dart';

class AttributesScores {
  static const int MIN_PRIMARY_ATTRIBUTE_VALUE = 1;
  static const int MIN_PRIMARY_ATTRIBUTE_INVESTED_POINTS = -90;
  static const int MIN_DERIVED_ATTRIBUTE_VALUE = 1;
  static const int DEFAULT_PRIMARY_ATTRIBUTE_VALUE = 10;

  int sizeModifier;

  /* ---- PRIMARY ATTRIBUTES ---- */

  int pointsInvestedInST;
  int get strength =>
      DEFAULT_PRIMARY_ATTRIBUTE_VALUE +
      pointsInvestedInST ~/ Attributes.ST.adjustPriceOf;

  int pointsInvestedInIQ;
  int get iq =>
      DEFAULT_PRIMARY_ATTRIBUTE_VALUE +
      pointsInvestedInIQ ~/ Attributes.IQ.adjustPriceOf;

  int pointsInvestedInDX;
  int get dexterity =>
      DEFAULT_PRIMARY_ATTRIBUTE_VALUE +
      pointsInvestedInDX ~/ Attributes.DX.adjustPriceOf;

  int pointsInvestedInHT;
  int get health =>
      DEFAULT_PRIMARY_ATTRIBUTE_VALUE +
      pointsInvestedInHT ~/ Attributes.HT.adjustPriceOf;

  /* ---- DERIVED ATTRIBUTES ---- */

  int pointsInvestedInHP;
  int get hitPoints =>
      strength +
      sizeModifier +
      pointsInvestedInHP ~/ Attributes.HP.adjustPriceOf;

  int pointsInvestedInWill;
  int get will => iq + pointsInvestedInWill ~/ Attributes.Will.adjustPriceOf;

  int pointsInvestedInPer;
  int get perception =>
      iq + pointsInvestedInPer ~/ Attributes.Per.adjustPriceOf;

  int pointsInvestedInBS;
  double get basicSpeed =>
      ((health + dexterity) / 4) +
      (pointsInvestedInBS / Attributes.BASIC_SPEED.adjustPriceOf);

  int pointsInvestedInBM;
  int get basicMove =>
      ((basicSpeed - (basicSpeed % 1)).toInt()) +
      pointsInvestedInBM ~/ Attributes.BASIC_MOVE.adjustPriceOf;

  int pointsInvestedInFP;
  int get fatiguePoints =>
      pointsInvestedInHT + pointsInvestedInFP ~/ Attributes.FP.adjustPriceOf;

  AttributesScores({
    this.sizeModifier = 0,
    this.pointsInvestedInST = 0,
    this.pointsInvestedInIQ = 0,
    this.pointsInvestedInDX = 0,
    this.pointsInvestedInHT = 0,
    this.pointsInvestedInHP = 0,
    this.pointsInvestedInWill = 0,
    this.pointsInvestedInPer = 0,
    this.pointsInvestedInBS = 0,
    this.pointsInvestedInBM = 0,
    this.pointsInvestedInFP = 0,
  });

  factory AttributesScores.fromJson(Map<String, dynamic> json) =>
      AttributesScores(
        pointsInvestedInST: json['st_points'],
        pointsInvestedInDX: json['dx_points'],
        pointsInvestedInIQ: json['iq_points'],
        pointsInvestedInHT: json['ht_points'],
        pointsInvestedInHP: json['hp_points'],
        pointsInvestedInWill: json['will_points'],
        pointsInvestedInPer: json['per_points'],
        pointsInvestedInBS: json['bs_points'],
        pointsInvestedInBM: json['bm_points'],
        pointsInvestedInFP: json['fp_points'],
      );

  Map<String, dynamic> get toJson => {
        'st_points': pointsInvestedInST,
        'dx_points': pointsInvestedInDX,
        'iq_points': pointsInvestedInIQ,
        'ht_points': pointsInvestedInHT,
        'hp_points': pointsInvestedInHP,
        'will_points': pointsInvestedInWill,
        'per_points': pointsInvestedInPer,
        'bs_points': pointsInvestedInBS,
        'bm_points': pointsInvestedInBM,
        'fp_points': pointsInvestedInFP,
      };

  double adjustPrimaryAttribute(
    Attributes stat,
    double newValue,
    int remainingPoints,
  ) {
    int investedPoints = getPointsInvestedIn(stat);

    if (investedPoints + newValue <= MIN_PRIMARY_ATTRIBUTE_INVESTED_POINTS) {
      return MIN_PRIMARY_ATTRIBUTE_INVESTED_POINTS.toDouble();
    }

    if (remainingPoints < newValue) {
      return investedPoints.toDouble();
    }

    return investedPoints + newValue;
  }

  double adjustDerivedAttribute(
    Attributes stat,
    double newValue,
    int remainingPoints,
  ) {
    int attributeValue = getPointsInvestedIn(stat);

    if (remainingPoints < newValue) {
      return attributeValue.toDouble();
    }

    if (getAttribute(stat) <= MIN_DERIVED_ATTRIBUTE_VALUE && newValue < 0) {
      return attributeValue.toDouble();
    }

    return attributeValue + newValue;
  }

  int getPointsInvestedIn(Attributes attribute) {
    switch (attribute) {
      case Attributes.ST:
        return pointsInvestedInST;
      case Attributes.DX:
        return pointsInvestedInDX;
      case Attributes.IQ:
        return pointsInvestedInIQ;
      case Attributes.HT:
        return pointsInvestedInHT;
      case Attributes.Per:
        return pointsInvestedInPer;
      case Attributes.Will:
        return pointsInvestedInWill;
      case Attributes.HP:
        return pointsInvestedInHP;
      case Attributes.FP:
        return pointsInvestedInFP;
      case Attributes.BASIC_SPEED:
        return pointsInvestedInBS;
      case Attributes.BASIC_MOVE:
        return pointsInvestedInBM;
      case Attributes.NONE:
        return 0;
    }
  }

  int getAttribute(Attributes attribute) {
    switch (attribute) {
      case Attributes.ST:
        return strength;
      case Attributes.DX:
        return dexterity;
      case Attributes.IQ:
        return iq;
      case Attributes.HT:
        return health;
      case Attributes.Per:
        return perception;
      case Attributes.Will:
        return will;
      case Attributes.HP:
        return hitPoints;
      case Attributes.FP:
        return fatiguePoints;
      case Attributes.BASIC_SPEED:
        return basicSpeed.toInt();
      case Attributes.BASIC_MOVE:
        return basicMove;
      case Attributes.NONE:
        return -1;
    }
  }
}
