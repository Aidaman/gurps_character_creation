import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/skills/models/skill_difficulty.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';

class SidebarProvider extends ChangeNotifier {
  bool _isSidebarVisible = false;
  bool get isSidebarVisible => _isSidebarVisible;

  TraitCategories selectedTraitCategory = TraitCategories.NONE;
  SkillDifficulty selectedSkillDifficulty = SkillDifficulty.NONE;

  void toggleSidebar(BuildContext context) {
    if (MediaQuery.of(context).size.width <= MIN_DESKTOP_WIDTH) {
      Scaffold.of(context).openEndDrawer();
      return;
    }

    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }
}
