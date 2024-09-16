import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character_provider.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/attribute_view.dart';
import 'package:gurps_character_creation/widgets/compose_page/custom_text_field.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_responsive_grid.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/spells/spell_view.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';
import 'package:provider/provider.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  bool _isSidebarVisible = true;

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
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final SidebarContent sidebar = SidebarContent(
      selectedCategory: selectedCategory,
      sidebarContent: sidebarContent,
      onTraitFilterButtonPressed: (TraitCategories category) {
        setState(() {
          sidebarContent = SidebarFutureTypes.TRAITS;

          if (selectedCategory == category) {
            selectedCategory = TraitCategories.NONE;
            return;
          }

          selectedCategory = category;
        });
      },
      onSidebarFutureChange: (SidebarFutureTypes type) {
        setState(() {
          if (type == SidebarFutureTypes.TRAITS &&
              sidebarContent == SidebarFutureTypes.TRAITS) {
            selectedCategory = TraitCategories.NONE;
            return;
          }

          sidebarContent = type;
        });
      },
    );

    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        title: Text(characterProvider.character.name),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        centerTitle: true,
        actions: [
          Text(
            'points: ${characterProvider.character.remainingPoints}/${characterProvider.character.points}',
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
        sidebarContent: sidebar,
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
          characterStats: List.from(_buildCharacterStats().map(
            (List<Widget> attributes) {
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: attributes,
                ),
              );
            },
          )),
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
          skillsAndMagic: [_generateSkills(), _generateMagic()],
          restOfTheBody: const [],
        ),
      ),
      endDrawer: MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH
          ? null
          : sidebar,
    );
  }

  @override
  void dispose() {
    for (var entry in _basicInfoControllers) {
      for (var e in entry.entries) {
        e.value.dispose();
      }
    }

    super.dispose();
  }

  Widget _generateMagic() {
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
      return _generateEmptyTraitOrSkillView(['spells']);
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: spells,
      ),
    );
  }

  Widget _generateSkills() {
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
      return _generateEmptyTraitOrSkillView(['Skills']);
    }

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: skills,
      ),
    );
  }

  List<List<Widget>> _buildCharacterStats() {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return [
      List.from(AttributesExtension.primaryAttributes.map(
        (Attributes attribute) {
          final int primaryAttributeValue =
              characterProvider.character.getAttribute(attribute);

          return AttributeView(
            attribute: attribute,
            stat: primaryAttributeValue,
            pointsSpent: characterProvider.character
                .getPointsSpentOnAttribute(attribute),
            onIncrement: () {
              characterProvider.updateCharacterField(
                attribute.stringValue,
                (primaryAttributeValue + attribute.adjustValueOf).toString(),
              );
            },
            onDecrement: () {
              characterProvider.updateCharacterField(
                attribute.stringValue,
                (primaryAttributeValue - attribute.adjustValueOf).toString(),
              );
            },
          );
        },
      )),
      List.from(AttributesExtension.derivedAttributes.map(
        (Attributes attribute) {
          final int derivedAttributesValue =
              characterProvider.character.getAttribute(attribute);

          return AttributeView(
            attribute: attribute,
            stat: derivedAttributesValue,
            pointsSpent: characterProvider.character
                .getPointsSpentOnAttribute(attribute),
            onIncrement: () {
              characterProvider.updateCharacterField(
                attribute.stringValue,
                (attribute.adjustPriceOf).toString(),
              );
            },
            onDecrement: () {
              characterProvider.updateCharacterField(
                attribute.stringValue,
                (attribute.adjustPriceOf * -1).toString(),
              );
            },
          );
        },
      )),
    ];
  }

  Widget _generateEmptyTraitOrSkillView(List<String> categories) {
    final String types = categories.join('/');
    const double DIVIDER_INDENT = 32;

    return Expanded(
      child: Column(
        children: [
          const Divider(
            endIndent: DIVIDER_INDENT,
            indent: DIVIDER_INDENT,
          ),
          Text('Click to add $types '),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Builder(builder: (context) {
              return IconButton.filled(
                onPressed: () {
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

  Widget _generateTraitView(List<TraitCategories> categories) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final Iterable<Trait> traits = characterProvider.character.traits.where(
      (trait) => trait.categories.any(
        (category) => categories.contains(category),
      ),
    );

    if (traits.isEmpty) {
      return _generateEmptyTraitOrSkillView(
        List.from(categories.map((TraitCategories tc) => tc.stringValue)),
      );
    }

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: List.from(traits.map(
          (Trait t) => TraitView(
            trait: t,
            onRemoveClick: () => characterProvider.removeTrait(t),
          ),
        )),
      ),
    );
  }

  List<Widget> _buildBasicInfoFields() {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    Widget generateSingleInput(Map<String, TextEditingController> map) {
      return Row(
        children: [
          const SizedBox(
            width: 8,
          ),
          CustomTextField(
            textEditingController: map.entries.first.value,
            onChanged: (value) {
              characterProvider.updateCharacterField(
                  map.entries.first.key, value);
            },
            fieldName: map.entries.first.key,
          ),
          const SizedBox(
            width: 8,
          ),
        ],
      );
    }

    return _basicInfoControllers
        .map((map) {
          final bool isSingleElement = map.entries.length == 1;

          if (isSingleElement) {
            return generateSingleInput(map);
          }

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.from(map.entries.map(
                (e) => CustomTextField(
                  onChanged: (value) {
                    characterProvider.updateCharacterField(e.key, value);
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
}
