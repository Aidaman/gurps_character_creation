import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/equipment/models/posession.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/equipment/services/possessions_service.dart';

class PossessionsProvider extends ChangeNotifier {
  final CharacterProvider characterProvider;
  final PossessionsService possessionsService;

  PossessionsProvider(this.characterProvider, this.possessionsService);

  List<Possession> readAll() {
    return possessionsService.readAll(characterProvider.character);
  }

  Possession read(String id) {
    return possessionsService.read(characterProvider.character, id);
  }

  void create(Possession possession) {
    possessionsService.add(characterProvider.character, possession);

    characterProvider.markDirty();
    notifyListeners();
  }

  void update(Possession newPossession) {
    possessionsService.update(characterProvider.character, newPossession);

    characterProvider.markDirty();
    notifyListeners();
  }

  void delete(String possessionId) {
    possessionsService.delete(characterProvider.character, possessionId);

    characterProvider.markDirty();
    notifyListeners();
  }
}
