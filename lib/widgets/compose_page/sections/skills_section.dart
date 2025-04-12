import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/services/character/providers/skill_provider.dart';
import 'package:gurps_character_creation/services/character/providers/spells_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/spells/spell_view.dart';

class SkillsSection extends StatelessWidget {
  final Widget Function(List<String> categories) emptyListBuilder;
  final SkillsProvider skillsProvider;
  final SpellsProvider spellsProvider;

  const SkillsSection({
    super.key,
    required this.emptyListBuilder,
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
      return emptyListBuilder(['spells']);
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
      return emptyListBuilder(['skills']);
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
