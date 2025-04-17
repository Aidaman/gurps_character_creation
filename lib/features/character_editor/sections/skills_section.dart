import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_filter_provider.dart';
import 'package:gurps_character_creation/features/character_editor/widgets/empty_category_action.dart';
import 'package:gurps_character_creation/features/skills/models/skill.dart';
import 'package:gurps_character_creation/features/spells/models/spell.dart';
import 'package:gurps_character_creation/features/skills/providers/skill_provider.dart';
import 'package:gurps_character_creation/features/spells/providers/spells_provider.dart';
import 'package:gurps_character_creation/features/skills/widgets/skill_view.dart';
import 'package:gurps_character_creation/features/spells/widgets/spell_view.dart';

class SkillsSection extends StatelessWidget {
  final SkillsProvider skillsProvider;
  final SpellsProvider spellsProvider;

  const SkillsSection({
    super.key,
    required this.skillsProvider,
    required this.spellsProvider,
  });

  Widget _buildSpellList(BuildContext context) {
    final List<Widget> spells = List.from(
      spellsProvider.readAll().map(
            (Spell spl) => SpellView(
              spell: spl,
              isIncluded: true,
              onRemoveClick: () {
                spellsProvider.delete(spl);
              },
            ),
          ),
    );

    if (spellsProvider.readAll().isEmpty) {
      return EmptyCategoryAction(
        categories: [SidebarFutureTypes.MAGIC.stringValue],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: spells,
    );
  }

  Widget _buildSkillList(BuildContext context) {
    final List<Widget> skills = List.from(
      skillsProvider.readAll().map(
            (Skill skl) => SkillView(
              skill: skl,
              isIncluded: true,
              onRemoveClick: () {
                skillsProvider.delete(skl);
              },
            ),
          ),
    );

    if (skills.isEmpty) {
      return EmptyCategoryAction(categories: [
        SidebarFutureTypes.SKILLS.stringValue,
      ]);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: skills,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    if (isMobile) {
      return Column(
        children: [
          _buildSpellList(context),
          _buildSkillList(context),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSpellList(context)),
        Expanded(child: _buildSkillList(context)),
      ],
    );
  }
}
