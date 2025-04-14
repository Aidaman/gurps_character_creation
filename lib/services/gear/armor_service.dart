import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/services/character_crud_service.dart';

class ArmorService extends CharacterCRUDService<Armor> {
  @override
  void add(Character character, Armor item) {
    character.armor.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.armor.removeWhere((armor) => armor.id == id);
  }

  @override
  Armor read(Character character, String id) {
    return character.armor.firstWhere(
      (armor) => armor.id == id,
    );
  }

  @override
  List<Armor> readAll(Character character) {
    return character.armor;
  }

  @override
  void update(Character character, Armor item) {
    character.armor = character.armor.map((armor) {
      if (armor.id == item.id) {
        return item;
      }
      return armor;
    }).toList();
  }
}
