import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon.dart';
import 'package:gurps_character_creation/services/character_crud_service.dart';

class WeaponService extends CharacterCRUDService<Weapon> {
  @override
  void create(Character character, Weapon item) {
    character.weapons.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.weapons =
        character.weapons.where((Weapon element) => element.id != id).toList();
  }

  @override
  Weapon read(Character character, String id) {
    return character.weapons.firstWhere((Weapon element) => element.id == id);
  }

  @override
  List<Weapon> readAll(Character character) {
    return character.weapons;
  }

  @override
  void update(Character character, Weapon item) {
    character.weapons = character.weapons
        .map(
          (Weapon element) => element.id == item.id ? item : element,
        )
        .toList();
  }
}
