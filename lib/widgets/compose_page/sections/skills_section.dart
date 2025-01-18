import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/characteristics/spells/spell.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/spells/spell_view.dart';
import 'package:provider/provider.dart';

class SkillsSection extends StatelessWidget {
  final Widget Function(List<String> categories) emptyListBuilder;

  const SkillsSection({super.key, required this.emptyListBuilder});

  Widget _buildSpellList(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final List<Widget> spells = List.from(
      characterProvider.character.spells.map(
        (Spell spl) => SpellView(
          spell: spl,
          isIncluded: true,
          onRemoveClick: () {
            characterProvider.removeSpell(spl);
          },
        ),
      ),
    );

    if (characterProvider.character.spells.isEmpty) {
      return emptyListBuilder(['spells']);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: spells,
    );
  }

  Widget _buildSkillList(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final List<Widget> skills = List.from(
      characterProvider.character.skills.map(
        (Skill skl) => SkillView(
          skill: skl,
          isIncluded: true,
          onRemoveClick: () {
            characterProvider.removeSkill(skl);
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
