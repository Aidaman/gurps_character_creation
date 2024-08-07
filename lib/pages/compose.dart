import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_stat.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/button/%20labeled_icon_button.dart';
import 'package:gurps_character_creation/widgets/compose_page/custom_text_field.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_responsive_grid.dart';
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
      'Players Name': TextEditingController(),
      'Character Name': TextEditingController(),
    },
    {
      'Age': TextEditingController(),
      'Height': TextEditingController(),
    },
    {
      'Weight': TextEditingController(),
      'Size Modifier': TextEditingController(),
    },
  ];

  void _updateCharacterField(String key, String value) {
    setState(() {
      switch (key) {
        case 'Players Name':
          widget.character.playerName = value;
          break;
        case 'Character Name':
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
        case 'Size Modifier':
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

  void _openSideBar(BuildContext context, {bool? value}) {
    if (value != null) {
      setState(() {
        _isSidebarVisible = value;
      });
      return;
    }

    if (MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH) {
      setState(() {
        _isSidebarVisible = !_isSidebarVisible;
      });
      return;
    }

    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        title: Text(widget.character.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        centerTitle: true,
        actions: [
          Text(
            'points: ${widget.character.remainingPoints}/${widget.character.points}',
          ),
          const SizedBox(
            width: 32,
          ),
          if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH)
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.now_widgets_outlined),
                onPressed: () => _openSideBar(context),
              );
            }),
        ],
      ),
      floatingActionButton: Builder(builder: (context) {
        return FloatingActionButton(
          child: const Icon(Icons.now_widgets_outlined),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
          },
        );
      }),
      body: ComposePageLayout(
        isSidebarVisible: MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH
            ? _isSidebarVisible
            : false,
        sidebarContent: _buildSidebarContent(),
        bodyContent: ComposePageResponsiveGrid(
          basicInfoFields: [
            Container(
              constraints: const BoxConstraints(
                maxHeight: 128,
                maxWidth: 128,
                minHeight: 86,
                minWidth: 86,
              ),
              child: const Placeholder(
                child: Icon(
                  Icons.person_4_outlined,
                  size: 48,
                ),
              ),
            ),
            const SizedBox(
              width: DESKTOP_COLUMNS_SPACING,
            ),
            ..._buildBasicInfoFields(),
          ],
          characterStats: [
            Column(
              children: List.from(SkillStatExtension.baseStats().map(
                (stat) => Row(
                  children: [
                    Text(
                      stat.abbreviatedStringValue,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      widget.character.getPrimaryAttribute(stat).toString(),
                    ),
                  ],
                ),
              )),
            )
          ],
          traits: [
            _generateTraitView([
              TraitCategories.ADVANTAGE,
              TraitCategories.PERK,
            ]),
            _generateTraitView([
              TraitCategories.DISADVANTAGE,
              TraitCategories.QUIRK,
            ]),
          ],
          skillsAndMagic: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.from(widget.character.skills.map(
                  (skl) => SkillView(skill: skl),
                )),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children:
                    List.from(widget.character.spells.map((spl) => ListTile(
                          title: Text(spl.name),
                          subtitle: Text(spl.college.first),
                        ))),
              ),
            )
          ],
          restOfTheBody: [],
        ),
      ),
      endDrawer: MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH
          ? null
          : Drawer(
              child: _buildSidebarContent(),
            ),
    );
  }

  Widget _generateTraitView(List<TraitCategories> categories) {
    final Iterable<Trait> traits = widget.character.traits.where(
      (trait) => trait.categories.any(
        (category) => categories.contains(category),
      ),
    );

    if (traits.isEmpty) {
      final String types = categories.map((c) => c.stringValue).join('/');

      return Expanded(
        child: Column(
          children: [
            const Divider(),
            Text('Click to add $types '),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Builder(builder: (context) {
                return IconButton.filled(
                  onPressed: () {
                    onTraitFilterButtonPressed(categories.first);
                    _openSideBar(context, value: true);
                  },
                  icon: const Icon(Icons.add),
                );
              }),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.from(traits.map(
          (e) => TraitView(trait: e),
        )),
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

  List<Widget> _buildBasicInfoFields() {
    return _basicInfoControllers
        .map((map) {
          final bool isSingleElement = map.entries.length == 1;

          if (isSingleElement) {
            return _generateSingleInput(map);
          }

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.from(map.entries.map(
                (e) => CustomTextField(
                  onChanged: (value) {
                    _updateCharacterField(e.key, value);
                  },
                  fieldName: e.key,
                  textEditingController: e.value,
                ),
              )),
            ),
          );
        })
        .map((element) {
          return [
            element,
            const SizedBox(
              width: DESKTOP_COLUMNS_SPACING,
            )
          ];
        })
        .expand(
          (pair) => pair,
        )
        .toList();
  }

  Widget _generateSingleInput(Map<String, TextEditingController> map) {
    return Row(
      children: [
        const SizedBox(
          width: 8,
        ),
        CustomTextField(
          textEditingController: map.entries.first.value,
          onChanged: (value) {
            _updateCharacterField(map.entries.first.key, value);
          },
          fieldName: map.entries.first.key,
        ),
        const SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget _buildSidebarContent() {
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
          child: switch (sidebarContent) {
            SidebarFutureTypes.TRAITS => _buildTraitList(),
            SidebarFutureTypes.SKILLS => _buildSkillList(),
            SidebarFutureTypes.MAGIC => _buildSpellList(),
          },
        ),
      ],
    );
  }

  Wrap _buildFilters() {
    return Wrap(
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
