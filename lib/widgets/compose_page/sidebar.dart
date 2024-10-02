import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character_provider.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_difficulty.dart';
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
  Timer? _debounce;

  static const double _FILTER_SPACING = 24.0;
  static const double _FILTER_RUN_SPACING = 0.0;

  static const double SIDEBAR_HORIZONTAL_PADDING = 8.0;
  static const double SIDEBAR_VERTICAL_PADDING = 4.0;

  late Future<List<Spell>> _spellsFuture;
  late Future<List<Trait>> _traitsFuture;
  late Future<List<Skill>> _skillsFuture;

  @override
  void initState() {
    _spellsFuture = loadSpells();
    _traitsFuture = loadTraits();
    _skillsFuture = loadSkills();

    super.initState();
  }

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
              SidebarFutureTypes.TRAITS => _buildFutureList(
                  future: _traitsFuture,
                  errorText: 'errorText',
                  noDataText: 'noDataText',
                  filterPredicate: (trt) =>
                      trt.name.toLowerCase().contains(_filterValue) &&
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
              SidebarFutureTypes.SKILLS => _buildFutureList(
                  future: _skillsFuture,
                  errorText: 'errorText',
                  noDataText: 'noDataText',
                  filterPredicate: (skl) =>
                      skl.name.toLowerCase().contains(_filterValue),
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
              SidebarFutureTypes.MAGIC => _buildFutureList(
                  future: _spellsFuture,
                  errorText: 'errorText',
                  noDataText: 'noDataText',
                  filterPredicate: (spl) =>
                      spl.name.toLowerCase().contains(_filterValue),
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
      decoration: const InputDecoration(labelText: 'Filter'),
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

  FutureBuilder<List<T>> _buildFutureList<T>({
    required Future<List<T>> future,
    required Widget Function(T item) itemBuilder,
    required String errorText,
    required String noDataText,
    bool Function(T item)? filterPredicate,
  }) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: $errorText ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(noDataText));
        }

        List<T> data = snapshot.data!;
        if (filterPredicate != null) {
          data = data.where(filterPredicate).toList();
        }

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => itemBuilder(data[index]),
        );
      },
    );
  }
}
