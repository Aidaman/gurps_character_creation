import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/equipment/models/armor.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/equipment/services/armor_service.dart';

class ArmorProvider with ChangeNotifier {
  final CharacterProvider characterProvider;
  final ArmorService armorService;

  ArmorProvider(this.characterProvider, this.armorService);

  List<Armor> readAll() {
    return armorService.readAll(characterProvider.character);
  }

  Armor read(String id) {
    return armorService.read(characterProvider.character, id);
  }

  void create(Armor armor) {
    armorService.add(characterProvider.character, armor);

    characterProvider.markDirty();
    notifyListeners();
  }

  void update(Armor newArmor) {
    armorService.update(characterProvider.character, newArmor);

    characterProvider.markDirty();
    notifyListeners();
  }

  void delete(String armorId) {
    armorService.delete(characterProvider.character, armorId);

    characterProvider.markDirty();
    notifyListeners();
  }
}
