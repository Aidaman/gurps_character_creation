import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/aspects/models/aspect.dart';
import 'package:gurps_character_creation/features/skills/models/skill.dart';
import 'package:gurps_character_creation/features/skills/models/skill_difficulty.dart';
import 'package:gurps_character_creation/features/spells/models/spell.dart';
import 'package:gurps_character_creation/features/traits/models/trait.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';

enum SidebarFutureTypes {
  TRAITS,
  SKILLS,
  MAGIC,
}

extension SidebarFutureTypesStringExtension on SidebarFutureTypes {
  String get stringValue {
    switch (this) {
      case SidebarFutureTypes.TRAITS:
        return 'Traits';
      case SidebarFutureTypes.SKILLS:
        return 'Skills';
      case SidebarFutureTypes.MAGIC:
        return 'Magic';
    }
  }

  static SidebarFutureTypes fromString(String value) {
    switch (value.toLowerCase()) {
      case 'traits':
      case 'advantages':
      case 'disadvantages':
      case 'perks':
      case 'quirks':
        return SidebarFutureTypes.TRAITS;
      case 'skills':
        return SidebarFutureTypes.SKILLS;
      case 'magic':
      case 'spells':
        return SidebarFutureTypes.MAGIC;
      default:
        return SidebarFutureTypes.TRAITS;
    }
  }
}

class SidebarFilterProvider with ChangeNotifier {
  String _filterQuerry = '';
  SidebarFutureTypes _sidebarContent = SidebarFutureTypes.TRAITS;
  List<TraitCategories> _selectedTraitCategories = [];
  List<SkillDifficulty> _selectedSkillDifficulties = [];

  String get filterQuerry => _filterQuerry;
  List<TraitCategories> get selectedTraitCategories => _selectedTraitCategories;
  List<SkillDifficulty> get selectedSkillDifficulty =>
      _selectedSkillDifficulties;
  SidebarFutureTypes get sidebarContent => _sidebarContent;

  set sidebarContent(SidebarFutureTypes type) {
    _sidebarContent = type;
    notifyListeners();
  }

  set filterQuerry(String value) {
    _filterQuerry = value;
    notifyListeners();
  }

  void clearFilters() {
    _filterQuerry = '';
    _selectedTraitCategories = [];
    _selectedSkillDifficulties = [];
    notifyListeners();
  }

  void addSelectedTraitCategory(TraitCategories category) {
    _selectedTraitCategories = [..._selectedTraitCategories, category];

    notifyListeners();
  }

  void removeSelectedTraitCategory(TraitCategories category) {
    _selectedTraitCategories = _selectedTraitCategories
        .where((TraitCategories cat) => cat != category)
        .toList();

    notifyListeners();
  }

  void addSelectedSkillDifficulty(SkillDifficulty difficulty) {
    _selectedSkillDifficulties = [..._selectedSkillDifficulties, difficulty];

    notifyListeners();
  }

  void removeSelectedSkillDifficulty(SkillDifficulty difficulty) {
    _selectedSkillDifficulties = _selectedSkillDifficulties
        .where((SkillDifficulty diff) => diff != difficulty)
        .toList();

    notifyListeners();
  }

  bool filterPredicate<T extends Aspect>(T aspect) {
    String nameLowerCase = aspect.name.toLowerCase();
    String queryLowerCase = filterQuerry.toLowerCase();

    bool matchesFilterQuerry = nameLowerCase.contains(queryLowerCase);

    if (aspect is Trait) {
      final Iterable<TraitCategories> categories = selectedTraitCategories
          .where((TraitCategories cat) => cat != TraitCategories.NONE);

      if (categories.isEmpty && queryLowerCase.isEmpty) {
        return true;
      }

      if (categories.isNotEmpty && queryLowerCase.isEmpty) {
        return categories.contains(aspect.category);
      }

      return matchesFilterQuerry && categories.contains(aspect.category);
    }

    if (aspect is Skill) {
      final Iterable<SkillDifficulty> difficulties = _selectedSkillDifficulties
          .where((SkillDifficulty diff) => diff != SkillDifficulty.NONE);

      if (difficulties.isEmpty && queryLowerCase.isEmpty) {
        return true;
      }

      if (difficulties.isNotEmpty && queryLowerCase.isEmpty) {
        return difficulties.contains(aspect.difficulty);
      }

      return matchesFilterQuerry && difficulties.contains(aspect.difficulty);
    }

    if (aspect is Spell) {
      if (selectedSkillDifficulty.isEmpty && !matchesFilterQuerry) {
        return true;
      }

      if (selectedSkillDifficulty.isEmpty) {
        return matchesFilterQuerry;
      }

      return matchesFilterQuerry &&
          selectedSkillDifficulty.contains(aspect.difficulty);
    }

    return matchesFilterQuerry;
  }
}
