import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/character/character.dart';

class CharacterAttributesService {
  void update(
    Character character, {
    required Attributes attribute,
    required double value,
  }) {
    switch (attribute) {
      case Attributes.ST:
        character.attributes.pointsInvestedInST = character.attributes
            .adjustPrimaryAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.DX:
        character.attributes.pointsInvestedInDX = character.attributes
            .adjustPrimaryAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.IQ:
        character.attributes.pointsInvestedInIQ = character.attributes
            .adjustPrimaryAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.HT:
        character.attributes.pointsInvestedInHT = character.attributes
            .adjustPrimaryAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
        break;
      case Attributes.Per:
        character.attributes.pointsInvestedInPer = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.Will:
        character.attributes.pointsInvestedInWill = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.HP:
        character.attributes.pointsInvestedInHP = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.FP:
        character.attributes.pointsInvestedInFP = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.BASIC_SPEED:
        character.attributes.pointsInvestedInBS = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      case Attributes.BASIC_MOVE:
        character.attributes.pointsInvestedInBM = character.attributes
            .adjustDerivedAttribute(
              attribute,
              value,
              character.remainingPoints,
            )
            .toInt();
      default:
        throw ArgumentError('Invalid Attribute: ${attribute.stringValue}');
    }
  }

  int getField(Character character, Attributes attribute) {
    return character.attributes.getAttribute(attribute);
  }

  int getPointsInvested(Character character, Attributes attribute) {
    return character.attributes.getPointsInvestedIn(attribute);
  }
}
