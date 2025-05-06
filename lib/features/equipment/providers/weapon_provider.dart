import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/equipment/services/weapon_service.dart';

class CharacterWeaponProvider with ChangeNotifier {
  final CharacterProvider _characterProvider;
  final WeaponService _weaponService;

  CharacterWeaponProvider(
    CharacterProvider characterProvider,
    WeaponService weaponService,
  )   : _characterProvider = characterProvider,
        _weaponService = weaponService;

  List<Weapon> readAll() {
    return _weaponService.readAll(_characterProvider.character);
  }

  Weapon read(String id) {
    return _weaponService.read(_characterProvider.character, id);
  }

  void create(Weapon weapon) {
    _weaponService.add(_characterProvider.character, weapon);

    _characterProvider.markDirty();
    notifyListeners();
  }

  void update(Weapon newWeapon) {
    _weaponService.update(_characterProvider.character, newWeapon);

    _characterProvider.markDirty();
    notifyListeners();
  }

  void delete(String weaponId) {
    _weaponService.delete(_characterProvider.character, weaponId);

    _characterProvider.markDirty();
    notifyListeners();
  }
}
