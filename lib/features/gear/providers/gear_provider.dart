import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/gear/models/armor.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/ranged_weapon.dart';

class GearProvider with ChangeNotifier {
  List<HandWeapon> _handWeapons = [];
  List<RangedWeapon> _rangedWeapons = [];
  List<Armor> _armors = [];

  List<HandWeapon> get handWeapons => _handWeapons;
  List<RangedWeapon> get rangedWeapons => _rangedWeapons;
  List<Armor> get armors => _armors;

  Future<void> loadGear() async {
    if (_handWeapons.isEmpty) {
      _handWeapons = await loadHandWeapons();
    }

    // if (_rangedWeapons.isEmpty) {
    //   _rangedWeapons = await loadRangedWeapons();
    // }

    // if (_armors.isEmpty) {
    //   _armors = await loadArmors();
    // }

    notifyListeners();
  }
}
