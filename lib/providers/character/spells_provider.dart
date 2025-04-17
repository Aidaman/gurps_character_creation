import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/providers/character/aspects_provider.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/services/character/spells_serivce.dart';

class SpellsProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterSpellsSerivce _spellsService;

  SpellsProvider(
    CharacterProvider characterProvider,
    CharacterSpellsSerivce spellsService,
  )   : _characterProvider = characterProvider,
        _spellsService = spellsService;

  void add(Spell s) {
    _spellsService.add(_characterProvider.character, s);

    notifyListeners();
  }

  void addByName(String spellName, AspectsProvider aspectsProvider) {
    if (!aspectsProvider.spells.any((s) => s.name.toLowerCase() == spellName)) {
      return;
    }

    _spellsService.add(
      _characterProvider.character,
      aspectsProvider.spells.singleWhere(
        (s) => s.name.toLowerCase() == spellName,
      ),
    );

    notifyListeners();
  }

  void delete(Spell s) {
    _spellsService.delete(_characterProvider.character, s.id);

    notifyListeners();
  }

  Spell read(Spell s) {
    return _spellsService.read(_characterProvider.character, s.id);
  }

  List<Spell> readAll() {
    return _spellsService.readAll(_characterProvider.character);
  }

  void update(Spell newSpell) {
    _spellsService.update(_characterProvider.character, newSpell);

    notifyListeners();
  }

  Future<void> updateSpellLevel(
    Spell s, {
    required bool doIncrease,
    int points = 1,
  }) async {
    if (doIncrease) {
      _spellsService.increaseSpellLevel(
        _characterProvider.character,
        s,
        points: points,
      );

      notifyListeners();
      return;
    }

    _spellsService.reduceSpellLevel(
      _characterProvider.character,
      s,
      points: points,
    );

    notifyListeners();
  }
}
