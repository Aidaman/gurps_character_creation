import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/button/%20labeled_icon_button.dart';
import 'package:gurps_character_creation/widgets/compose_page/expanded_text_field.dart';
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
  final Character character;

  ComposePage({super.key, Character? character})
      : character = character ?? Character.empty();

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  bool _isSidebarVisible = true;
  String _filterValue = '';

  TraitCategories selectedCategory = TraitCategories.NONE;
  SidebarFutureTypes sidebarContent = SidebarFutureTypes.TRAITS;

  final List<Map<String, TextEditingController>> _basicInfoControllers = [
    {
      'PlayersName': TextEditingController(),
    },
    {
      'CharacterName': TextEditingController(),
    },
    {
      'Age': TextEditingController(),
      'Height': TextEditingController(),
      'Weight': TextEditingController(),
      'SizeModifier': TextEditingController(),
    },
  ];

  void _updateCharacterField(String key, String value) {
    setState(() {
      switch (key) {
        case 'PlayersName':
          widget.character.playerName = value;
          break;
        case 'CharacterName':
          widget.character.name = value;
          break;
        case 'Age':
          widget.character.age = int.tryParse(value) ?? widget.character.age;
          break;
        case 'Height':
          widget.character.height =
              int.tryParse(value) ?? widget.character.height;
          break;
        case 'Weight':
          widget.character.weight =
              int.tryParse(value) ?? widget.character.weight;
          break;
        case 'SizeModifier':
          widget.character.sizeModifier =
              int.tryParse(value) ?? widget.character.sizeModifier;
          break;
        default:
          break;
      }
    });
  }

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
          LabeledIconButton(
            iconValue: Icons.handyman_outlined,
            onPressed: () {
              setState(() {
                sidebarContent = SidebarFutureTypes.SKILLS;
              });
            },
            label: 'Skills',
          ),
          LabeledIconButton(
            iconValue: Icons.bolt_outlined,
            onPressed: () {
              setState(() {
                sidebarContent = SidebarFutureTypes.MAGIC;
              });
            },
            label: 'Magic',
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
        actions: [
          Text(
            'points: ${widget.character.remainingPoints}/${widget.character.points}',
          ),
          const SizedBox(
            width: 32,
          ),
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
        bodyContent: ResponsiveGrid(
          children: [
            const Placeholder(),
            _basicInfoFields,
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

  @override
  void dispose() {
    for (var entry in _basicInfoControllers) {
      for (var e in entry.entries) {
        e.value.dispose;
      }
    }

    super.dispose();
  }

  Widget get _basicInfoFields => Column(
        children: List.from(
          _basicInfoControllers.map(
            (map) {
              final Iterable<MapEntry<String, TextEditingController>> elements =
                  map.entries;
              if (map.entries.length == 1 ||
                  MediaQuery.of(context).size.width < MAX_MOBILE_WIDTH) {
                return ExpandedTextField(
                  textEditingController: elements.first.value,
                  onChanged: (value) {
                    _updateCharacterField(elements.first.key, value);
                  },
                  fieldName: elements.first.key,
                );
              } else {
                final List<Widget> children = List.from(elements.map(
                  (e) => ExpandedTextField(
                    textEditingController: e.value,
                    onChanged: (value) {
                      _updateCharacterField(e.key, value);
                    },
                    fieldName: e.key,
                  ),
                ));

                return Row(
                  children: children,
                );
              }
            },
          ),
        ),
      );

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
          child: switch (sidebarContent) {
            SidebarFutureTypes.TRAITS => _buildTraitList(),
            SidebarFutureTypes.SKILLS => _buildSkillList(),
            SidebarFutureTypes.MAGIC => _buildSpellList(),
          },
        ),
      ],
    );
  }

  FutureBuilder<List<Spell>> _buildSpellList() {
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
          itemBuilder: (context, index) => ListTile(
            title: Text(spells[index].name),
            subtitle: Text(spells[index].prereqList.join(', ')),
          ),
        );
      },
    );
  }

  FutureBuilder<List<Skill>> _buildSkillList() {
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
          itemBuilder: (context, index) => SkillView(skill: skills[index]),
        );
      },
    );
  }

  FutureBuilder<List<Trait>> _buildTraitList() {
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
          itemBuilder: (context, index) => TraitView(trait: traits[index]),
        );
      },
    );
  }
}
