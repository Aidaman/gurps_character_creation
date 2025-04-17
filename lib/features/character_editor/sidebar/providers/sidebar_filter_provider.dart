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

    if (aspect.runtimeType case Trait) {
      if (selectedTraitCategories.isEmpty && !matchesFilterQuerry) {
        return true;
      }

      if (selectedSkillDifficulty.isEmpty) {
        return matchesFilterQuerry;
      }

      return matchesFilterQuerry &&
          selectedTraitCategories.contains((aspect as Trait).category);
    }

    if (aspect.runtimeType case Skill) {
      if (selectedSkillDifficulty.isEmpty && !matchesFilterQuerry) {
        return true;
      }

      if (selectedSkillDifficulty.isEmpty) {
        return matchesFilterQuerry;
      }

      return matchesFilterQuerry &&
          selectedSkillDifficulty.contains((aspect as Skill).difficulty);
    }

    if (aspect.runtimeType case Spell) {
      if (selectedSkillDifficulty.isEmpty && !matchesFilterQuerry) {
        return true;
      }

      if (selectedSkillDifficulty.isEmpty) {
        return matchesFilterQuerry;
      }

      return matchesFilterQuerry &&
          selectedSkillDifficulty.contains((aspect as Spell).difficulty);
    } else {
      return matchesFilterQuerry;
    }
  }
}
