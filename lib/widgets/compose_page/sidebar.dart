import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/characteristics/spells/spell.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
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
  Timer? _debounce;

  static const double _FILTER_SPACING = 24.0;
  static const double _FILTER_RUN_SPACING = 0.0;

  static const double SIDEBAR_HORIZONTAL_PADDING = 8.0;
  static const double SIDEBAR_VERTICAL_PADDING = 4.0;

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

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
                  _buildSearchField(),
                ],
              ),
            ),
          ),
          Expanded(
            child: switch (widget.sidebarContent) {
              SidebarFutureTypes.TRAITS => _buildList<Trait>(
                  list: Provider.of<AspectsProvider>(context).traits,
                  noDataText: 'noDataText',
                  filterPredicate: (trt) =>
                      trt.name.toLowerCase().contains(
                            _filterValue.toLowerCase(),
                          ) &&
                      (widget.selectedCategory == TraitCategories.NONE
                          ? true
                          : trt.categories.contains(widget.selectedCategory)),
                  itemBuilder: (trt) => TraitView(
                    trait: trt,
                    onAddClick: () {
                      characterProvider.addTrait(trt);
                    },
                    onRemoveClick: () {
                      characterProvider.removeTrait(trt);
                    },
                  ),
                ),
              SidebarFutureTypes.SKILLS => _buildList<Skill>(
                  list: Provider.of<AspectsProvider>(context).skills,
                  noDataText: 'noDataText',
                  filterPredicate: (skl) => skl.name.toLowerCase().contains(
                        _filterValue.toLowerCase(),
                      ),
                  itemBuilder: (skl) => SkillView(
                    skill: skl,
                    onAddClick: () {
                      characterProvider.addSkill(skl);
                    },
                    onRemoveClick: () {
                      characterProvider.removeSkill(skl);
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
                    onAddClick: () {
                      characterProvider.addSpell(spl);
                    },
                    onRemoveClick: () {
                      characterProvider.removeSpell(spl);
                    },
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
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
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          enabledBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              width: 0.5,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.75),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(
              width: 0.5,
              color: Theme.of(context).colorScheme.primary.withOpacity(1),
            ),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
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
            runSpacing: _FILTER_RUN_SPACING,
            spacing: _FILTER_SPACING,
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

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => itemBuilder(
        list.elementAt(
          index,
        ),
      ),
    );
  }
}
