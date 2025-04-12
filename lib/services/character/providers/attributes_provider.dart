import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/services/character/attributes_service.dart';
import 'package:gurps_character_creation/services/character/providers/character_provider.dart';

class AttributesProvider extends ChangeNotifier {
  final CharacterProvider _characterProvider;
  final CharacterAttributesService _attributesService;

  AttributesProvider(
    CharacterProvider characterProvider,
    CharacterAttributesService attributesService,
  )   : _characterProvider = characterProvider,
        _attributesService = attributesService;

  void update({
    required Attributes attribute,
    required double value,
  }) {
    _attributesService.update(
      _characterProvider.character,
      attribute: attribute,
      value: value,
    );

    _characterProvider.markDirty();
    notifyListeners();
  }

  int getField(Attributes attribute) {
    return _attributesService.getField(_characterProvider.character, attribute);
  }

  int getPointsInvested(Attributes attribute) {
    return _attributesService.getPointsInvested(
      _characterProvider.character,
      attribute,
    );
  }
}
