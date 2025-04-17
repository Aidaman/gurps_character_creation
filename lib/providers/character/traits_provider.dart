import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/character/aspects_provider.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/traits_service.dart';
import 'package:provider/provider.dart';

class TraitsProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterTraitsService _traitsService;

  TraitsProvider(
    CharacterProvider characterProvider,
    CharacterTraitsService traitsService,
  )   : _characterProvider = characterProvider,
        _traitsService = traitsService;

  void add(Trait t) {
    _traitsService.add(_characterProvider.character, t);

    notifyListeners();
  }

  void delete(Trait t) {
    _traitsService.delete(_characterProvider.character, t.id);

    notifyListeners();
  }

  Trait read(Trait t) {
    return _traitsService.read(_characterProvider.character, t.id);
  }

  List<Trait> readAll() {
    return _traitsService.readAll(_characterProvider.character);
  }

  List<Trait> readAllOfCategory(TraitCategories category) {
    return _traitsService.readAllOfCategory(
      _characterProvider.character,
      category,
    );
  }

  List<Trait> readAllOfMultipleCategories(
      Iterable<TraitCategories> categories) {
    return _traitsService.readAllOfMultipleCategories(
      _characterProvider.character,
      categories,
    );
  }

  void update(Trait newTrait) {
    _traitsService.update(_characterProvider.character, newTrait);

    notifyListeners();
  }

  Future<void> updateTraitTitle(Trait t, BuildContext context) async {
    String? newTitle = await Provider.of<AspectsProvider>(
      context,
      listen: false,
    ).replacePlacholderName(
      context,
      t.name,
    );
    _traitsService.updateTraitTitle(_characterProvider.character, t, newTitle);

    notifyListeners();
  }

  void updateTraitLevel(Trait t, {required bool doIncrease}) {
    if (doIncrease) {
      _traitsService.increaseTraitLevel(_characterProvider.character, t);
      notifyListeners();
      return;
    }

    _traitsService.reduceTraitLevel(_characterProvider.character, t);
    notifyListeners();
  }
}
