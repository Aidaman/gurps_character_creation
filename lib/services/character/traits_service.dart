import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/services/character_crud_service.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/change_aspect_placeholder.dart';

class CharacterTraitsService extends CharacterCRUDService<Trait> {
  @override
  void add(Character character, Trait item) {
    character.traits.add(item);
  }

  @override
  void delete(Character character, String id) {
    character.traits.removeWhere((Trait trait) => trait.id == id);
  }

  @override
  Trait read(Character character, String id) {
    return character.traits.firstWhere((Trait trait) => trait.id == id);
  }

  @override
  List<Trait> readAll(Character character) {
    return character.traits;
  }

  List<Trait> readAllOfCategory(Character character, TraitCategories category) {
    return character.traits
        .where((Trait trait) => trait.category == category)
        .toList();
  }

  List<Trait> readAllOfMultipleCategories(
    Character character,
    Iterable<TraitCategories> categories,
  ) {
    return character.traits
        .where(
          (Trait trait) => categories.contains(trait.category),
        )
        .toList();
  }

  @override
  void update(Character character, Trait item) {
    character.traits = character.traits.map((Trait trait) {
      if (trait.id == item.id) {
        return item;
      }

      return trait;
    }).toList();
  }

  void updateTraitTitle(Character character, Trait trait, String? newTitle) {
    if (newTitle == null) {
      return;
    }

    delete(character, trait.id);

    trait.placeholder = newTitle;
    add(character, trait);
  }

  Future<String?> replacePlacholderName(
    BuildContext context,
    String name,
  ) async {
    final RegExpMatch match = placeholderAspectRegex.firstMatch(name)!;
    final String placeholder = match.group(1) ?? '';

    final String? replacedWith = await showDialog<String>(
      context: context,
      builder: (context) => ChangeAspectPlaceholderNameDialog(
        placeholder: placeholder,
      ),
    );

    if (replacedWith == null) {
      return null;
    }

    return replacedWith.replaceAll(match.group(0)!, replacedWith);
  }

  void increaseTraitLevel(Character character, Trait t) {
    if (!t.canLevel) {
      return;
    }

    if (character.remainingPoints < t.pointsPerLevel) {
      return;
    }

    t.investedPoints += t.pointsPerLevel;
  }

  void reduceTraitLevel(Character character, Trait t) {
    if (!t.canLevel) {
      return;
    }

    if (t.investedPoints == 0) {
      return;
    }

    t.investedPoints -= t.pointsPerLevel;
  }
}
