// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/aspects/models/aspect.dart';
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

enum SidebarFutureTypes {
  TRAITS,
  SKILLS,
  MAGIC,
}

class SidebarAspectsTab extends StatefulWidget {
  final TraitCategories selectedTraitCategory;
  final SkillDifficulty selectedSkillDifficulty;
  final SidebarFutureTypes content;
  final void Function(TraitCategories category) onTraitFilterButtonPressed;
  final void Function(SkillDifficulty category) onSkillFilterButtonPressed;
  final void Function(SidebarFutureTypes type) onSidebarFutureChange;

  const SidebarAspectsTab({
    super.key,
    required this.selectedTraitCategory,
    required this.selectedSkillDifficulty,
    required this.content,
    required this.onTraitFilterButtonPressed,
    required this.onSidebarFutureChange,
    required this.onSkillFilterButtonPressed,
  });

  @override
  State<SidebarAspectsTab> createState() => _SidebarAspectsTabState();
}

class _SidebarAspectsTabState extends State<SidebarAspectsTab> {
  String _filterValue = '';
  Timer? _debounce;

  static const double _FILTER_SPACING = 24.0;
  static const double _FILTER_RUN_SPACING = 0.0;

  static const double SIDEBAR_HORIZONTAL_PADDING = 8.0;
  static const double SIDEBAR_VERTICAL_PADDING = 4.0;

  @override
  Widget build(BuildContext context) {
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
                _buildFilters(),
                const Gap(16),
                _buildSearchField(),
              ],
            ),
          ),
        ),
        Expanded(
          child: switch (widget.content) {
            SidebarFutureTypes.TRAITS => _buildList<Trait>(
                list: Provider.of<AspectsProvider>(context).traits,
                noDataText: 'noDataText',
                filterPredicate: (trt) =>
                    trt.name.toLowerCase().contains(
                          _filterValue.toLowerCase(),
                        ) &&
                    (widget.selectedTraitCategory == TraitCategories.NONE
                        ? true
                        : trt.category == widget.selectedTraitCategory),
                itemBuilder: (Trait trt) => TraitView(
                  trait: trt,
                  onAddClick: () => _addAspect(trt),
                  onRemoveClick: () {
                    context.read<TraitsProvider>().delete(trt);
                  },
                ),
              ),
            SidebarFutureTypes.SKILLS => _buildList<Skill>(
                list: Provider.of<AspectsProvider>(context).skills,
                noDataText: 'noDataText',
                filterPredicate: (skl) =>
                    skl.name.toLowerCase().contains(
                          _filterValue.toLowerCase(),
                        ) &&
                    (widget.selectedSkillDifficulty == SkillDifficulty.NONE
                        ? true
                        : skl.difficulty == widget.selectedSkillDifficulty),
                itemBuilder: (skl) => SkillView(
                  skill: skl,
                  onAddClick: () => _addAspect(skl),
                  onRemoveClick: () {
                    context.read<SkillsProvider>().delete(skl);
                  },
                ),
              ),
            SidebarFutureTypes.MAGIC => _buildList<Spell>(
                list: Provider.of<AspectsProvider>(context).spells,
                noDataText: 'noDataText',
                filterPredicate: (spl) => spl.name.toLowerCase().contains(
                      _filterValue.toLowerCase(),
                    ),
                itemBuilder: (spl) => SpellView(
                  spell: spl,
                  onAddClick: () => _addAspect(spl),
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

  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        if (_debounce?.isActive ?? false) {
          _debounce?.cancel();
        }

        _debounce = Timer(
          const Duration(
            milliseconds: 300,
          ),
          () => setState(() {
            _filterValue = value;
          }),
        );
      },
      decoration: InputDecoration(
        labelText: 'Filter',
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide.none,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.spaceAround,
          runSpacing: _FILTER_RUN_SPACING,
          spacing: _FILTER_SPACING,
          children: [
            LabeledIconButton(
              iconValue: Icons.accessibility_outlined,
              onPressed: () => widget.onSidebarFutureChange(
                SidebarFutureTypes.TRAITS,
              ),
              label: 'Traits',
              backgroundColor: widget.content == SidebarFutureTypes.TRAITS
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            LabeledIconButton(
              iconValue: Icons.handyman_outlined,
              onPressed: () => widget.onSidebarFutureChange(
                SidebarFutureTypes.SKILLS,
              ),
              label: 'Skills',
              backgroundColor: widget.content == SidebarFutureTypes.SKILLS
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            LabeledIconButton(
              iconValue: Icons.bolt_outlined,
              onPressed: () => widget.onSidebarFutureChange(
                SidebarFutureTypes.MAGIC,
              ),
              label: 'Magic',
              backgroundColor: widget.content == SidebarFutureTypes.MAGIC
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          ],
        ),
        if (widget.content == SidebarFutureTypes.TRAITS)
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
                    (TraitCategories category) => LabeledIconButton(
                      iconValue: category.iconValue,
                      onPressed: () =>
                          widget.onTraitFilterButtonPressed(category),
                      label: category.stringValue,
                      backgroundColor: widget.selectedTraitCategory == category
                          ? Theme.of(context).colorScheme.secondary
                          : null,
                    ),
                  ),
            ),
          )
        else if (widget.content == SidebarFutureTypes.SKILLS)
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
                    (SkillDifficulty category) => LabeledIconButton(
                      iconValue: category.iconValue,
                      onPressed: () =>
                          widget.onSkillFilterButtonPressed(category),
                      label: category.stringValue,
                      backgroundColor:
                          widget.selectedSkillDifficulty == category
                              ? Theme.of(context).colorScheme.secondary
                              : null,
                    ),
                  ),
            ),
          )
      ],
    );
  }

  Widget _buildList<T>({
    required List<T> list,
    required Widget Function(T item) itemBuilder,
    required String noDataText,
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
            'We\'re sorry, there is nothing found',
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

  void _addAspect(Aspect aspect) async {
    String? newName;

    if (placeholderAspectRegex.hasMatch(aspect.name)) {
      newName = await Provider.of<AspectsProvider>(
        context,
        listen: false,
      ).replacePlacholderName(
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
