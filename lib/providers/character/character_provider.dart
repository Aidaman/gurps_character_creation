import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/change_aspect_placeholder.dart';
import 'package:provider/provider.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();

  Character get character => _character;

  bool _isDirty = false;
  bool get isDirty => _isDirty;

  void clearProgress() {
    _character = Character.empty();
    _isDirty = false;
  }

  void updateCharacterMaxPoints(int? newValue) {
    _character.points = newValue ?? _character.points;
    notifyListeners();
  }

  void updateCharacterField(String key, String value) {
    switch (key) {
      case 'Strength':
        _character.attributes.pointsInvestedInST = _character.attributes
            .adjustPrimaryAttribute(
              Attributes.ST,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Dexterity':
        _character.attributes.pointsInvestedInDX = _character.attributes
            .adjustPrimaryAttribute(
              Attributes.DX,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'IQ':
        _character.attributes.pointsInvestedInIQ = _character.attributes
            .adjustPrimaryAttribute(
              Attributes.IQ,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Health':
        _character.attributes.pointsInvestedInHT = _character.attributes
            .adjustPrimaryAttribute(
              Attributes.HT,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Perception':
        _character.attributes.pointsInvestedInPer = _character.attributes
            .adjustDerivedAttribute(
              Attributes.Per,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Will':
        _character.attributes.pointsInvestedInWill = _character.attributes
            .adjustDerivedAttribute(
              Attributes.Will,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Hit Points':
        _character.attributes.pointsInvestedInHP = _character.attributes
            .adjustDerivedAttribute(
              Attributes.HP,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Fatigue Points':
        _character.attributes.pointsInvestedInFP = _character.attributes
            .adjustDerivedAttribute(
              Attributes.FP,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Basic Speed':
        _character.attributes.pointsInvestedInBS = _character.attributes
            .adjustDerivedAttribute(
              Attributes.BASIC_SPEED,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      case 'Basic Move':
        _character.attributes.pointsInvestedInBM = _character.attributes
            .adjustDerivedAttribute(
              Attributes.BASIC_MOVE,
              double.parse(value),
              _character.remainingPoints,
            )
            .toInt();
      default:
    }

    _isDirty = true;

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

    _isDirty = true;
    notifyListeners();
  }

  void updateTraitTitle(Trait trait, String? newTitle) {
    if (newTitle == null) {
      return;
    }

    removeTrait(trait);

    trait.placeholder = newTitle;
    addTrait(trait);

    notifyListeners();
  }

  void removeTrait(Trait trait) {
    _character.traits.removeWhere(
      (t) => t.name == trait.name,
    );

    _isDirty = true;
    notifyListeners();
  }

  void addSkill(Skill skill) {
    if (_character.skills.any((s) => s.name == skill.name)) {
      return;
    }

    _character.skills.add(Skill.copyWith(skill, investedPoints: 1));

    _isDirty = true;
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

    _isDirty = true;
    notifyListeners();
  }

  void adjustSpellInvestedPoints(Spell spell, int adjustment) {
    if (adjustment <= 0 && spell.investedPoints == 1) {
      return;
    }

    if (character.remainingPoints - adjustment > character.points) {
      return;
    }

    if (character.remainingPoints - adjustment < 0) {
      return;
    }

    spell.investedPoints += adjustment;

    _isDirty = true;
    notifyListeners();
  }

  void removeSkill(Skill skill) {
    _character.skills.removeWhere(
      (s) => s.name == skill.name,
    );

    _isDirty = true;
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

    _isDirty = true;
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void addSpellByName(String spellName, BuildContext context) {
    if (_character.spells.any((s) => s.name == spellName)) {
      return;
    }

    final AspectsProvider aspectsProvider =
        Provider.of<AspectsProvider>(context, listen: false);

    if (!aspectsProvider.spells.any((s) => s.name.toLowerCase() == spellName)) {
      return;
    }

    addSpell(aspectsProvider.spells.singleWhere(
      (s) => s.name.toLowerCase() == spellName,
    ));

    notifyListeners();
  }

  void removeSpell(Spell spell) {
    _character.spells.removeWhere(
      (s) => s.name == spell.name,
    );

    _isDirty = true;
    refreshSpellUnsatisfiedPrereqs();
    notifyListeners();
  }

  void addArmor(Armor armor) {
    _character.armor.add(armor);

    _isDirty = true;
    notifyListeners();
  }

  void updateArmor(Armor newArmor) {
    _character.armor = _character.armor
        .map(
          (Armor armor) => armor.id == newArmor.id ? newArmor : armor,
        )
        .toList();

    _isDirty = true;
    notifyListeners();
  }

  void removeArmor(Armor armorToRemove) {
    _character.armor.removeWhere(
      (Armor armor) => armor.id == armorToRemove.id,
    );

    _isDirty = true;
    notifyListeners();
  }

  void addPossession(Posession poss) {
    _character.possessions.add(poss);

    _isDirty = true;
    notifyListeners();
  }

  void updatePossession(Posession newPossession) {
    _character.possessions = _character.possessions
        .map(
          (Posession poss) =>
              poss.id == newPossession.id ? newPossession : poss,
        )
        .toList();

    _isDirty = true;
    notifyListeners();
  }

  void removePossession(Posession possessonToRemove) {
    _character.possessions.removeWhere(
      (Posession poss) => poss.id == possessonToRemove.id,
    );

    _isDirty = true;
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

  void setProfilePicture(String path) {
    _character.personalInfo.avatarURL = path;

    _isDirty = true;
    notifyListeners();
  }

  void markDirty() {
    _isDirty = true;
  }

  void increaseTraitLevel(Trait t) {
    if (!t.canLevel) {
      return;
    }

    if (character.remainingPoints < t.pointsPerLevel) {
      return;
    }

    t.investedPoints += t.pointsPerLevel;

    _isDirty = true;
    notifyListeners();
  }

  void reduceTraitLevel(Trait t) {
    if (!t.canLevel) {
      return;
    }

    if (t.investedPoints == 0) {
      return;
    }

    t.investedPoints -= t.pointsPerLevel;

    _isDirty = true;
    notifyListeners();
  }

  void loadCharacterFromJson(Map<String, dynamic> jsonData) {
    _character = Character.fromJson(jsonData);

    notifyListeners();
  }
}
