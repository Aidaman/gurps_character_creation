import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/weapon.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/gear/services/weapon_service.dart';

class CharacterWeaponProvider with ChangeNotifier {
  final CharacterProvider characterProvider;
  final WeaponService weaponService;

  CharacterWeaponProvider(this.characterProvider, this.weaponService);

  List<Weapon> readAll() {
    return weaponService.readAll(characterProvider.character);
  }

  Weapon read(String id) {
    return weaponService.read(characterProvider.character, id);
  }

  void create(Weapon weapon) {
    weaponService.add(characterProvider.character, weapon);

    characterProvider.markDirty();
    notifyListeners();
  }

  void update(Weapon newWeapon) {
    weaponService.update(characterProvider.character, newWeapon);

    characterProvider.markDirty();
    notifyListeners();
  }

  void delete(String weaponId) {
    weaponService.delete(characterProvider.character, weaponId);

    characterProvider.markDirty();
    notifyListeners();
  }
}
