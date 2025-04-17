import 'package:gurps_character_creation/features/character/models/character.dart';

class CharacterPersonalInfoService {
  void update(
    Character character, {
    required String field,
    required dynamic value,
  }) {
    switch (field.toLowerCase()) {
      case 'character name':
        character.personalInfo.name = value.toString();
        break;
      case 'players name':
        character.personalInfo.playerName = value.toString();
        break;
      case 'avatarurl':
        character.personalInfo.avatarURL = value.toString();
        break;
      case 'appearanceDetails':
        character.personalInfo.appearanceDetails = value.toString();
        break;
      case 'age':
        character.personalInfo.age = int.parse(value);
        break;
      case 'height':
        character.personalInfo.height = int.parse(value);
        break;
      case 'weight':
        character.personalInfo.weight = int.parse(value);
        break;
      case 'size modifier':
        character.personalInfo.sizeModifier = int.parse(value);
        break;
      default:
        throw ArgumentError('Invalid field: $field');
    }
  }

  String getField(Character character, String field) {
    return switch (field.toLowerCase()) {
      'character name' => character.personalInfo.name,
      'players name' => character.personalInfo.playerName,
      'avatarurl' => character.personalInfo.avatarURL,
      'appearanceDetails' => character.personalInfo.appearanceDetails,
      'age' => character.personalInfo.age.toString(),
      'height' => character.personalInfo.height.toString(),
      'weight' => character.personalInfo.weight.toString(),
      'size modifier' => character.personalInfo.sizeModifier.toString(),
      String() => throw ArgumentError('Invalid field: $field'),
    };
  }
}
