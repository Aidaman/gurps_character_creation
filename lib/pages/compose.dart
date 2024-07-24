import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/button/%20labeled_icon_button.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_grid.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';

enum SidebarFutureTypes {
  TRAITS,
  SKILLS,
  MAGIC,
}

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  bool _isSidebarVisible = true;

  String _filterValue = '';

  TraitCategories selectedCategory = TraitCategories.NONE;
  SidebarFutureTypes sidebarContent = SidebarFutureTypes.TRAITS;

  Widget get _skillsIconButton => LabeledIconButton(
        iconValue: Icons.handyman_outlined,
        onPressed: () {
          setState(() {
            sidebarContent = SidebarFutureTypes.SKILLS;
          });
        },
        label: 'Skills',
      );

  Widget get _magicSpellsIconButton => LabeledIconButton(
        iconValue: Icons.bolt_outlined,
        onPressed: () {
          setState(() {
            sidebarContent = SidebarFutureTypes.MAGIC;
          });
        },
        label: 'Magic',
      );

  void onTraitFilterButtonPressed(TraitCategories category) {
    setState(() {
      sidebarContent = SidebarFutureTypes.TRAITS;

      if (selectedCategory == category) {
        selectedCategory = TraitCategories.NONE;
        return;
      }

      selectedCategory = category;
    });
  }

  Widget get _filters => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.spaceAround,
        runSpacing: 0,
        spacing: 24,
        children: [
          ...TraitCategories.values.map(
            (category) => LabeledIconButton(
              iconValue: category.iconValue,
              onPressed: () => onTraitFilterButtonPressed(category),
              label: category.stringValue,
            ),
          ),
          _skillsIconButton,
          _magicSpellsIconButton
        ],
      );

  Widget get _filterSearchField => TextField(
        onChanged: (value) => setState(() {
          _filterValue = value;
        }),
        decoration: const InputDecoration(labelText: 'Filter'),
      );

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Compose'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
        actions: [
          if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH)
            IconButton(
              icon: const Icon(Icons.now_widgets_outlined),
              onPressed: () => setState(() {
                _isSidebarVisible = !_isSidebarVisible;
              }),
            ),
        ],
      ),
      body: ComposePageLayout(
        isSidebarVisible: _isSidebarVisible,
        sidebarContent: _sidebarContent,
        bodyContent: const ResponsiveGrid(
          children: [
            Column(
              children: [
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
              ],
            ),
            Column(
              children: [
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
                Text('aaaa'),
              ],
            ),
          ],
        ),
      ),
      endDrawer: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
          ? null
          : Drawer(
              child: _sidebarContent,
            ),
    );
  }

  Widget get _sidebarContent {
    return Column(
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
              horizontal: 8.0,
              vertical: 4,
            ),
            child: Column(
              children: [
                _filters,
                _filterSearchField,
              ],
            ),
          ),
        ),
        Expanded(
            child: switch (sidebarContent) {
          SidebarFutureTypes.TRAITS => FutureBuilder<List<Trait>>(
              future: loadTraits(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data found.'));
                }

                final List<Trait> traits = snapshot.data!
                    .where(
                      (element) => selectedCategory == TraitCategories.NONE
                          ? true
                          : element.categories.contains(selectedCategory),
                    )
                    .where(
                      (element) => element.name
                          .toLowerCase()
                          .contains(_filterValue.toLowerCase()),
                    )
                    .toList();
                return ListView.builder(
                  itemCount: traits.length,
                  itemBuilder: (context, index) =>
                      TraitView(trait: traits[index]),
                );
              },
            ),
          SidebarFutureTypes.SKILLS => FutureBuilder<List<Skill>>(
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
                  itemBuilder: (context, index) =>
                      SkillView(skill: skills[index]),
                );
              },
            ),
          SidebarFutureTypes.MAGIC => FutureBuilder(
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
                  itemBuilder: (context, index) => ListTile(
                    title: Text(spells[index].name),
                    subtitle: Text(spells[index].prereqList.join(', ')),
                  ),
                );
              },
            ),
        }),
      ],
    );
  }
}
