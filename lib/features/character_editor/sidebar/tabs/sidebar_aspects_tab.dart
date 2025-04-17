// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/aspects/models/aspect.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_filter_provider.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/widgets/search_field.dart';
import 'package:gurps_character_creation/features/skills/models/skill_difficulty.dart';
import 'package:gurps_character_creation/features/traits/models/trait_modifier.dart';
import 'package:gurps_character_creation/features/skills/models/skill.dart';
import 'package:gurps_character_creation/features/spells/models/spell.dart';
import 'package:gurps_character_creation/features/traits/models/trait.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/skills/providers/skill_provider.dart';
import 'package:gurps_character_creation/features/spells/providers/spells_provider.dart';
import 'package:gurps_character_creation/features/traits/providers/traits_provider.dart';
import 'package:gurps_character_creation/widgets/button/labeled_icon_button.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/select_trait_modifiers.dart';
import 'package:gurps_character_creation/features/skills/widgets/skill_view.dart';
import 'package:gurps_character_creation/features/spells/widgets/spell_view.dart';
import 'package:gurps_character_creation/features/traits/widgets/trait_view.dart';
import 'package:provider/provider.dart';

class SidebarAspectsTab extends StatelessWidget {
  const SidebarAspectsTab({super.key});

  static const double _FILTER_SPACING = 24.0;
  static const double _FILTER_RUN_SPACING = 0.0;

  static const double SIDEBAR_HORIZONTAL_PADDING = 8.0;
  static const double SIDEBAR_VERTICAL_PADDING = 4.0;

  @override
  Widget build(BuildContext context) {
    SidebarFilterProvider filter = context.watch<SidebarFilterProvider>();

    return Column(
      children: [
        Container(
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
                _buildFilters(context),
                const Gap(16),
                SearchField(
                  onSearchChanged: (value) {
                    filter.filterQuerry = value;
                  },
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: switch (filter.sidebarContent) {
            SidebarFutureTypes.TRAITS => _buildList<Trait>(
                list: Provider.of<AspectsProvider>(context).traits,
                noDataText: 'No match found',
                filterPredicate: (item) => context
                    .read<SidebarFilterProvider>()
                    .filterPredicate<Trait>(item),
                context: context,
                itemBuilder: (item) => TraitView(
                  trait: item,
                  onAddClick: () => _addAspect(item, context),
                  onRemoveClick: () {
                    context.read<TraitsProvider>().delete(item);
                  },
                ),
              ),
            SidebarFutureTypes.SKILLS => _buildList<Skill>(
                list: Provider.of<AspectsProvider>(context).skills,
                noDataText: 'No match found',
                filterPredicate: (skl) => context
                    .read<SidebarFilterProvider>()
                    .filterPredicate<Skill>(skl),
                context: context,
                itemBuilder: (skl) => SkillView(
                  skill: skl,
                  onAddClick: () => _addAspect(skl, context),
                  onRemoveClick: () {
                    context.read<SkillsProvider>().delete(skl);
                  },
                ),
              ),
            SidebarFutureTypes.MAGIC => _buildList<Spell>(
                list: Provider.of<AspectsProvider>(context).spells,
                noDataText: 'No match found',
                filterPredicate: (spl) => context
                    .read<SidebarFilterProvider>()
                    .filterPredicate<Spell>(spl),
                context: context,
                itemBuilder: (spl) => SpellView(
                  spell: spl,
                  onAddClick: () => _addAspect(spl, context),
                  onRemoveClick: () {
                    context.read<SpellsProvider>().delete(spl);
                  },
                ),
              ),
          },
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    SidebarFilterProvider filter = context.watch<SidebarFilterProvider>();

    return Column(
      children: [
        _buildSidebarContentFilter(context),
        if (filter.sidebarContent == SidebarFutureTypes.TRAITS)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceAround,
            runSpacing: _FILTER_RUN_SPACING,
            spacing: _FILTER_SPACING,
            children: List.from(
              TraitCategories.values
                  .where((c) => c != TraitCategories.NONE)
                  .map(
                    (category) => _buildTraitCategoryFilter(
                      category,
                      context,
                    ),
                  ),
            ),
          )
        else if (filter.sidebarContent == SidebarFutureTypes.SKILLS)
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.spaceAround,
            runSpacing: _FILTER_RUN_SPACING,
            spacing: _FILTER_SPACING,
            children: List.from(
              SkillDifficulty.values
                  .where((c) => c != SkillDifficulty.NONE)
                  .map(
                    (category) => _buildSkillsFilter(
                      category,
                      context,
                    ),
                  ),
            ),
          )
      ],
    );
  }

  Widget _buildSidebarContentFilter(BuildContext context) {
    SidebarFilterProvider filter = context.watch<SidebarFilterProvider>();

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceAround,
      runSpacing: _FILTER_RUN_SPACING,
      spacing: _FILTER_SPACING,
      children: [
        LabeledIconButton(
          iconValue: Icons.accessibility_outlined,
          onPressed: () {
            filter.sidebarContent = SidebarFutureTypes.TRAITS;
          },
          label: 'Traits',
          backgroundColor: filter.sidebarContent == SidebarFutureTypes.TRAITS
              ? Theme.of(context).colorScheme.secondary
              : null,
        ),
        LabeledIconButton(
          iconValue: Icons.handyman_outlined,
          onPressed: () {
            filter.sidebarContent = SidebarFutureTypes.SKILLS;
          },
          label: 'Skills',
          backgroundColor: filter.sidebarContent == SidebarFutureTypes.SKILLS
              ? Theme.of(context).colorScheme.secondary
              : null,
        ),
        LabeledIconButton(
          iconValue: Icons.bolt_outlined,
          onPressed: () {
            filter.sidebarContent = SidebarFutureTypes.MAGIC;
          },
          label: 'Magic',
          backgroundColor: filter.sidebarContent == SidebarFutureTypes.MAGIC
              ? Theme.of(context).colorScheme.secondary
              : null,
        ),
      ],
    );
  }

  Widget _buildSkillsFilter(SkillDifficulty category, BuildContext context) {
    SidebarFilterProvider filter = context.read<SidebarFilterProvider>();

    return LabeledIconButton(
      iconValue: category.iconValue,
      onPressed: () {
        bool hasThisValue = filter.selectedSkillDifficulty.contains(category);

        if (hasThisValue) {
          filter.removeSelectedSkillDifficulty(category);
          return;
        }

        filter.addSelectedSkillDifficulty(category);
      },
      label: category.stringValue,
      backgroundColor: context
              .read<SidebarFilterProvider>()
              .selectedSkillDifficulty
              .contains(category)
          ? Theme.of(context).colorScheme.secondary
          : null,
    );
  }

  Widget _buildTraitCategoryFilter(
      TraitCategories category, BuildContext context) {
    final SidebarFilterProvider filter = context.watch<SidebarFilterProvider>();

    return LabeledIconButton(
      onPressed: () {
        bool hasThisValue = filter.selectedTraitCategories.contains(category);
        if (hasThisValue) {
          filter.removeSelectedTraitCategory(category);
          return;
        }

        filter.addSelectedTraitCategory(category);
      },
      iconValue: category.iconValue,
      label: category.stringValue,
      backgroundColor: filter.selectedTraitCategories.contains(category)
          ? Theme.of(context).colorScheme.secondary
          : null,
    );
  }

  Widget _buildList<T>({
    required List<T> list,
    required Widget Function(T item) itemBuilder,
    required String noDataText,
    required BuildContext context,
    bool Function(T item)? filterPredicate,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Text(noDataText),
      );
    }

    if (filterPredicate != null) {
      list = list.where(filterPredicate).toList();
    }

    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            noDataText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Create your own thing!'),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => itemBuilder(
        list.elementAt(
          index,
        ),
      ),
    );
  }

  void _addAspect(Aspect aspect, BuildContext context) async {
    String? newName;

    final aspectsProvider = context.read<AspectsProvider>();

    if (placeholderAspectRegex.hasMatch(aspect.name)) {
      newName = await aspectsProvider.replacePlacholderName(
        context,
        aspect.name,
      );
    }

    if (aspect is Trait) {
      List<TraitModifier>? modifiers;

      if (aspect.modifiers.isNotEmpty) {
        modifiers = await showDialog<List<TraitModifier>>(
          context: context,
          builder: (context) => SelectTraitModifiersDialog(
            trait: aspect,
          ),
        );
      }

      Trait newTrait = Trait.copyWIth(aspect, selectedModifiers: modifiers);
      newTrait.placeholder = newName;

      context.read<TraitsProvider>().add(aspect);
    }

    if (aspect is Skill) {
      context.read<SkillsProvider>().add(aspect);
    }

    if (aspect is Spell) {
      context.read<SpellsProvider>().add(aspect);
    }
  }
}
