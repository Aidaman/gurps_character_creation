import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon.dart';
import 'package:gurps_character_creation/features/character/services/character_crud_service.dart';

class WeaponService extends CharacterCRUDService<Weapon> {
  @override
  void add(Character character, Weapon item) {
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
