import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/aspects/models/aspect.dart';
import 'package:gurps_character_creation/features/skills/models/skill.dart';
import 'package:gurps_character_creation/features/spells/models/spell.dart';
import 'package:gurps_character_creation/features/traits/models/trait.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/change_aspect_placeholder.dart';

class AspectsProvider extends ChangeNotifier {
  List<Trait> _traits = [];
  List<Skill> _skills = [];
  List<Spell> _spells = [];

  List<Trait> get traits => _traits;
  List<Skill> get skills => _skills;
  List<Spell> get spells => _spells;

  List<T> _filterAspectsByNames<T extends Aspect>(
    List<T> list,
  ) {
    final List<T> uniqueEntries = [];

    Set<String> seenNames = {};
    for (T element in list) {
      if (!seenNames.contains(element.name)) {
        seenNames.add(element.name);
        uniqueEntries.add(element);
      }
    }

    return uniqueEntries;
  }

  Future<void> loadCharacteristics() async {
    if (traits.isEmpty) {
      _traits = _filterAspectsByNames(await loadTraits());
    }

    if (_skills.isEmpty) {
      _skills = _filterAspectsByNames(await loadSkills());
    }

    if (_spells.isEmpty) {
      _spells = _filterAspectsByNames(await loadSpells());
    }

    notifyListeners();
  }

  Future<String?> replacePlacholderName(
    BuildContext context,
    String name,
  ) async {
    final RegExpMatch match = placeholderAspectRegex.firstMatch(name)!;
    final String placeholder = match.group(1) ?? '';

    final String? replacedWith = await context.showAdaptiveDialog<String>(
      builder: (context) => ChangeAspectPlaceholderNameDialog(
        placeholder: placeholder,
      ),
      isScrollControlled: false,
    );

    if (replacedWith == null) {
      return null;
    }

    return replacedWith.replaceAll(match.group(0)!, replacedWith);
  }
}
