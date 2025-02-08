import 'package:gurps_character_creation/models/character/character.dart';

class CharacterPersonalInfoService {
  void update(
    Character character, {
    required String field,
    required dynamic value,
  }) {
    switch (field) {
      case 'name':
        character.personalInfo.name = value.toString();
        break;
      case 'avatarURL':
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
}
