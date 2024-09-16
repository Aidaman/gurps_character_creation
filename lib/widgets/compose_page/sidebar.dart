import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character_provider.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/widgets/button/%20labeled_icon_button.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/spells/spell_view.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';
import 'package:provider/provider.dart';

enum SidebarFutureTypes {
  TRAITS,
  SKILLS,
  MAGIC,
}

class SidebarContent extends StatefulWidget {
  final TraitCategories selectedCategory;
  final SidebarFutureTypes sidebarContent;
  final void Function(TraitCategories category) onTraitFilterButtonPressed;
  final void Function(SidebarFutureTypes type) onSidebarFutureChange;

  const SidebarContent({
    super.key,
    required this.selectedCategory,
    required this.sidebarContent,
    required this.onTraitFilterButtonPressed,
    required this.onSidebarFutureChange,
  });

  @override
  State<SidebarContent> createState() => _SidebarContentState();
}

class _SidebarContentState extends State<SidebarContent> {
  String _filterValue = '';

  static const double SIDEBAR_HORIZONTAL_PADDING = 8.0;
  static const double SIDEBAR_VERTICAL_PADDING = 4.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            margin: const EdgeInsets.only(
              bottom: 8,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SIDEBAR_HORIZONTAL_PADDING,
                vertical: SIDEBAR_VERTICAL_PADDING,
              ),
              child: Column(
                children: [
                  _buildFilters(),
                  TextField(
                    onChanged: (value) => setState(() {
                      _filterValue = value;
                    }),
                    decoration: const InputDecoration(labelText: 'Filter'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (widget.sidebarContent) {
              SidebarFutureTypes.TRAITS => _buildTraitList(),
              SidebarFutureTypes.SKILLS => _buildSkillList(),
              SidebarFutureTypes.MAGIC => _buildSpellList(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const double FILTER_SPACING = 24.0;
    const double FILTER_RUN_SPACING = 0.0;

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.spaceAround,
          runSpacing: FILTER_RUN_SPACING,
          spacing: FILTER_SPACING,
          children: [
            LabeledIconButton(
              iconValue: Icons.accessibility_outlined,
              onPressed: () =>
                  widget.onSidebarFutureChange(SidebarFutureTypes.TRAITS),
              label: 'Traits',
            ),
            LabeledIconButton(
              iconValue: Icons.handyman_outlined,
              onPressed: () => widget.onSidebarFutureChange(
                SidebarFutureTypes.SKILLS,
              ),
              label: 'Skills',
            ),
            LabeledIconButton(
              iconValue: Icons.bolt_outlined,
              onPressed: () => widget.onSidebarFutureChange(
                SidebarFutureTypes.MAGIC,
              ),
              label: 'Magic',
            ),
          ],
        ),
        if (widget.sidebarContent == SidebarFutureTypes.TRAITS)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceAround,
            runSpacing: FILTER_RUN_SPACING,
            spacing: FILTER_SPACING,
            children: List.from(
              TraitCategories.values
                  .where((c) => c != TraitCategories.NONE)
                  .map(
                    (category) => LabeledIconButton(
                      iconValue: category.iconValue,
                      onPressed: () =>
                          widget.onTraitFilterButtonPressed(category),
                      label: category.stringValue,
                    ),
                  ),
            ),
          )
      ],
    );
  }

  FutureBuilder<List<Spell>> _buildSpellList() {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return FutureBuilder(
      future: loadSpells(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        final List<Spell> spells = snapshot.data!
            .where(
              (element) => element.name
                  .toLowerCase()
                  .contains(_filterValue.toLowerCase()),
            )
            .toList();

        return ListView.builder(
          itemCount: spells.length,
          itemBuilder: (context, index) => SpellView(
            spell: spells[index],
            onAddClick: () {
              characterProvider.addSpell(spells[index]);
            },
            onRemoveClick: () {
              characterProvider.removeSpell(spells[index]);
            },
          ),
        );
      },
    );
  }

  FutureBuilder<List<Skill>> _buildSkillList() {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return FutureBuilder<List<Skill>>(
      future: loadSkills(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        final List<Skill> skills = snapshot.data!
            .where(
              (element) => element.name
                  .toLowerCase()
                  .contains(_filterValue.toLowerCase()),
            )
            .toList();
        return ListView.builder(
          itemCount: skills.length,
          itemBuilder: (context, index) => SkillView(
            skill: skills[index],
            onAddClick: () {
              characterProvider.addSkill(skills[index]);
            },
            onRemoveClick: () {
              characterProvider.removeSkill(skills[index]);
            },
          ),
        );
      },
    );
  }

  FutureBuilder<List<Trait>> _buildTraitList() {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return FutureBuilder<List<Trait>>(
      future: loadTraits(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data found.'));
        }

        final List<Trait> traits = snapshot.data!
            .where(
              (element) => widget.selectedCategory == TraitCategories.NONE
                  ? true
                  : element.categories.contains(widget.selectedCategory),
            )
            .where(
              (element) => element.name
                  .toLowerCase()
                  .contains(_filterValue.toLowerCase()),
            )
            .toList();
        return ListView.builder(
          itemCount: traits.length,
          itemBuilder: (context, index) => TraitView(
            trait: traits[index],
            onAddClick: () => characterProvider.addTrait(traits[index]),
            onRemoveClick: () => characterProvider.removeTrait(traits[index]),
          ),
        );
      },
    );
  }
}
