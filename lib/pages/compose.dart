import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/models/gear/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/ranged_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/characteristics/spells/spell.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/hand_weapon_editor_dialog.dart';
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
  static const double _DIVIDER_INDENT = 32;

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
          handWeapons: [
            _buildHandWeapons(characterProvider),
          ],
          rangedWeapons: [
            _buildRangedWeapons(characterProvider),
          ],
          restOfTheBody: const [],
        ),
      ),
      endDrawer: MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH
          ? null
          : sidebar,
    );
  }

  Expanded _buildRangedWeapons(CharacterProvider characterProvider) {
    if (characterProvider.character.weapons.whereType<RangedWeapon>().isEmpty) {
      return Expanded(
        child: Column(
          children: [
            const Divider(
              endIndent: _DIVIDER_INDENT,
              indent: _DIVIDER_INDENT,
            ),
            const Text('Click to add a Ranged Weapon'),
            IconButton.filled(
              onPressed: () {
                characterProvider.addWeapon(RangedWeapon.empty());
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Column(
        children: [
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  ...RangedWeapon.empty().toDataTableColumns().keys.map(
                        (String key) => DataColumn(
                          label: Text(key),
                        ),
                      ),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: characterProvider.character.weapons
                    .whereType<RangedWeapon>()
                    .map(
                      (RangedWeapon rw) => _buildRangedWeaponDataCell(rw),
                    )
                    .toList(),
              ),
            ),
          ),
          IconButton.filled(
            onPressed: () {
              characterProvider.addWeapon(RangedWeapon.empty());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildHandWeapons(CharacterProvider characterProvider) {
    if (characterProvider.character.weapons.whereType<HandWeapon>().isEmpty) {
      return Expanded(
        child: Column(
          children: [
            const Divider(
              endIndent: _DIVIDER_INDENT,
              indent: _DIVIDER_INDENT,
            ),
            const Text('Click to add a Weapon'),
            IconButton.filled(
              onPressed: () async {
                HandWeapon? hw = await showDialog<HandWeapon?>(
                  context: context,
                  builder: (context) => const HandWeaponEditorDialog(),
                );

                if (hw != null) {
                  characterProvider.addWeapon(hw);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: Center(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  ...HandWeapon.empty().dataTableColumns.keys.map(
                        (String key) => DataColumn(
                          label: Text(key),
                        ),
                      ),
                  const DataColumn(label: Text('Actions')),
                ],
                rows: characterProvider.character.weapons
                    .whereType<HandWeapon>()
                    .map(
                      (HandWeapon hw) => _buildHandWeaponDataCell(hw),
                    )
                    .toList(),
              ),
            ),
            IconButton.filled(
              onPressed: () async {
                HandWeapon? hw = await showDialog<HandWeapon?>(
                  context: context,
                  builder: (context) => const HandWeaponEditorDialog(),
                );

                if (hw != null) {
                  characterProvider.addWeapon(hw);
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  DataRow _buildRangedWeaponDataCell(RangedWeapon rw) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    Iterable<DataCell> cells = rw.toDataTableColumns().entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          final Map<String, dynamic> json = e.value;
          if (Range.isRange(json)) {
            return DataCell(
              Text(
                Range.fromJson(json).toString(),
              ),
            );
          }

          if (WeaponStrengths.isWeaponStrengths(json)) {
            return DataCell(
              Text(
                WeaponStrengths.fromJson(json).toString(),
              ),
            );
          }

          if (RangeWeaponShots.isShots(json)) {
            return DataCell(
              Text(
                RangeWeaponShots.fromJson(json).toString(),
              ),
            );
          }
        }

        if (e.value is String) {
          final RangedWeaponLegalityClass legalityClass =
              RangedWeaponLegalityClassExtention.fromString(e.value);

          if (legalityClass != RangedWeaponLegalityClass.NONE) {
            return DataCell(Text(legalityClass.stringValue));
          }
        }

        return DataCell(Center(
          child: Text(
            e.value is String ? e.value : e.value.toString(),
          ),
        ));
      },
    ).toList();

    return DataRow(cells: [
      ...cells,
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => characterProvider.removeWeapon(rw),
              icon: const Icon(Icons.remove_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outlined),
            ),
          ],
        ),
      )
    ]);
  }

  DataRow _buildHandWeaponDataCell(HandWeapon hw) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    Iterable<DataCell> cells = hw.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          Map<String, dynamic> json = e.value;

          if (HandWeaponReach.isReach(json)) {
            return DataCell(
              Text(
                HandWeaponReach.fromJson(
                  json,
                ).toString(),
              ),
            );
          }

          if (WeaponDamage.isDamage(json)) {
            return DataCell(
              Text(
                WeaponDamage.fromJson(
                  json,
                ).calculateDamage(
                  characterProvider.character.getAttribute(Attributes.ST),
                  hw.minimumSt,
                ),
              ),
            );
          }
        }

        if (e.key == 'parry') {
          return _getParryCell(characterProvider, hw);
        }

        return DataCell(
          Center(
            child: Text(
              e.value is String ? e.value : e.value.toString(),
            ),
          ),
        );
      },
    );

    return DataRow(cells: [
      ...cells,
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                HandWeapon? newWeapon = await showDialog<HandWeapon?>(
                  context: context,
                  builder: (context) => HandWeaponEditorDialog(
                    oldHandWeapon: hw,
                  ),
                );

                if (newWeapon != null) {
                  characterProvider.updateWeapon(hw.id, newWeapon);
                }
              },
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => characterProvider.removeWeapon(hw),
              icon: const Icon(Icons.remove_outlined),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.info_outline),
            ),
          ],
        ),
      )
    ]);
  }

  DataCell _getParryCell(CharacterProvider characterProvider, HandWeapon hw) {
    int skillIndex = characterProvider.character.skills.indexWhere(
      (Skill skl) => skl.name == hw.associatedSkillName,
    );

    if (skillIndex == -1) {
      return DataCell(
        Center(
          child: Text(
            HandWeapon.calculateParry(0).toString(),
          ),
        ),
      );
    }

    Skill skill = characterProvider.character.skills.elementAt(skillIndex);

    int skillLevel = skill.skillLevel(
      characterProvider.character.getAttribute(skill.associatedAttribute),
    );

    return DataCell(
      Center(
        child: Text(
          HandWeapon.calculateParry(skillLevel).toString(),
        ),
      ),
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

    return Expanded(
      child: Column(
        children: [
          const Divider(
            endIndent: _DIVIDER_INDENT,
            indent: _DIVIDER_INDENT,
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
