import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/weapon.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/characteristics/spells/spell.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/change_aspect_placeholder.dart';

class CharacterProvider with ChangeNotifier {
  final Character _character = Character.empty();

  Character get character => _character;

  void updateCharacterField(String key, String value) {
    switch (key) {
      case 'Players Name':
        _character.playerName = value;
        break;
      case 'Character Name':
        _character.name = value;
        break;
      case 'Age':
        _character.age = int.tryParse(value) ?? _character.age;
        break;
      case 'Height':
        _character.height = int.tryParse(value) ?? _character.height;
        break;
      case 'Weight':
        _character.weight = int.tryParse(value) ?? _character.weight;
        break;
      case 'Size Modifier':
        _character.sizeModifier =
            int.tryParse(value) ?? _character.sizeModifier;
        break;
      case 'Strength':
        _character.strength = _character
            .adjustPrimaryAttribute(
              Attributes.ST,
              double.parse(value),
            )
            .toInt();
      case 'Dexterity':
        _character.dexterity = _character
            .adjustPrimaryAttribute(
              Attributes.DX,
              double.parse(value),
            )
            .toInt();
      case 'IQ':
        _character.iq = _character
            .adjustPrimaryAttribute(
              Attributes.IQ,
              double.parse(value),
            )
            .toInt();
      case 'Health':
        _character.health = _character
            .adjustPrimaryAttribute(
              Attributes.HT,
              double.parse(value),
            )
            .toInt();
      case 'Perception':
        if (_character.remainingPoints > Attributes.Per.adjustPriceOf) {
          _character.pointsSpentOnPer += int.parse(value);
        }
      case 'Will':
        if (_character.remainingPoints > Attributes.Will.adjustPriceOf) {
          _character.pointsSpentOnWill += int.parse(value);
        }
      case 'Hit Points':
        if (_character.remainingPoints > Attributes.HP.adjustPriceOf) {
          _character.pointsSpentOnHP += int.parse(value);
        }
      case 'Fatigue Points':
        if (_character.remainingPoints > Attributes.FP.adjustPriceOf) {
          _character.pointsSpentOnFP += int.parse(value);
        }
      case 'Basic Speed':
        if (_character.remainingPoints > Attributes.BASIC_SPEED.adjustPriceOf) {
          _character.pointsSpentOnBS += int.parse(value);
        }
      case 'Basic Move':
        if (_character.remainingPoints > Attributes.BASIC_MOVE.adjustPriceOf) {
          _character.pointsSpentOnBM += int.parse(value);
        }
      default:
    }

    notifyListeners();
  }

  void addTrait(Trait trait) {
    final bool isEnoughPoints = trait.basePoints < character.remainingPoints;
    final bool isTraitPresent =
        _character.traits.any((t) => t.name == trait.name);

    if (isTraitPresent || !isEnoughPoints) {
      return;
    }

    _character.traits.add(trait);
    notifyListeners();
  }

  void updateTraitTitle(Trait trait, String? newTitle) {
    if (newTitle == null) {
      return;
    }

    removeTrait(trait);

    trait.title = newTitle;
    addTrait(trait);

    notifyListeners();
  }

  void removeTrait(Trait trait) {
    _character.traits.removeWhere(
      (t) => t.name == trait.name,
    );
    notifyListeners();
  }

  void addSkill(Skill skill) {
    if (_character.skills.any((s) => s.name == skill.name)) {
      return;
    }

    _character.skills.add(Skill.copyWith(skill, investedPoints: 1));
    notifyListeners();
  }

  void adjustSkillInvestedPoints(Skill skill, int adjustment) {
    if (adjustment <= 0 && skill.investedPoints == 1) {
      return;
    }

    if (character.remainingPoints - adjustment > character.points) {
      return;
    }

    if (character.remainingPoints - adjustment < 0) {
      return;
    }

    skill.investedPoints += adjustment;
    notifyListeners();
  }

  void removeSkill(Skill skill) {
    _character.skills.removeWhere(
      (s) => s.name == skill.name,
    );
    notifyListeners();
  }

  void refreshSpellUnsatisfiedPrereqs() {
    _character.spells = _character.spells.map((spl) {
      final List<String> unsatisfitedPrerequisitesList = spl.prereqList
          .where(
            (s) => !_character.spells.any(
              (e) => e.name.toLowerCase() == s.toLowerCase(),
            ),
          )
          .toList();

      return Spell.copyWith(
        spl,
        unsatisfitedPrerequisitesList: unsatisfitedPrerequisitesList,
      );
    }).toList();
  }

  void addSpell(Spell spell) {
    if (_character.spells.any((s) => s.name == spell.name)) {
      return;
    }

    _character.spells.add(spell);

    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void removeSpell(Spell spell) {
    _character.spells.removeWhere(
      (s) => s.name == spell.name,
    );
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void addWeapon(Weapon weapon) {
    _character.weapons.add(weapon);
    notifyListeners();
  }

  void updateWeapon(String oldWeaponId, Weapon newWeapon) {
    int weaponIndex = _character.weapons.indexWhere(
      (Weapon wpn) => wpn.id == oldWeaponId,
    );

    if (weaponIndex == -1) {
      return;
    }

    _character.weapons[weaponIndex] = newWeapon;

    notifyListeners();
  }

  void removeWeapon(Weapon weapon) {
    _character.weapons.removeWhere(
      (Weapon wpn) => wpn.id == weapon.id,
    );
    notifyListeners();
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
}
