import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/gear/models/posession.dart';
import 'package:gurps_character_creation/features/character/services/character_crud_service.dart';

class PossessionsService extends CharacterCRUDService<Possession> {
  @override
  void add(Character character, item) {
    character.possessions.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.possessions.removeWhere((possession) => possession.id == id);
  }

  @override
  Possession read(Character character, String id) {
    return character.possessions
        .firstWhere((possession) => possession.id == id);
  }

  @override
  List<Possession> readAll(Character character) {
    return character.possessions;
  }

  @override
  void update(Character character, item) {
    character.possessions = character.possessions.map((possession) {
      if (possession.id == item.id) {
        return item;
      }
      return possession;
    }).toList();
  }
}
