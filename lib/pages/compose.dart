import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/edit_character_points_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/armor.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/basic_info_fields.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/character_attributes.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/hand_weapons.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/ranged_weapons.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/skills_and_magic.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/traits_view.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_responsive_grid.dart';
import 'package:provider/provider.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  static const double _DIVIDER_INDENT = 32;

  bool _isSidebarVisible = true;

  TraitCategories selectedTraitCategory = TraitCategories.NONE;
  SkillDifficulty selectedSkillDifficulty = SkillDifficulty.NONE;
  SidebarFutureTypes sidebarContent = SidebarFutureTypes.TRAITS;

  void _toggleSidebar(
    BuildContext context, {
    SidebarFutureTypes? content,
  }) {
    if (content != null) {
      setState(() {
        sidebarContent = content;
      });
    }

    if (MediaQuery.of(context).size.width <= MIN_DESKTOP_WIDTH) {
      Scaffold.of(context).openEndDrawer();
      return;
    }

    setState(() {
      _isSidebarVisible = !_isSidebarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final Widget sidebar = SafeArea(
      child: SidebarContent(
        selectedSkillDifficulty: selectedSkillDifficulty,
        selectedTraitCategory: selectedTraitCategory,
        sidebarContent: sidebarContent,
        onTraitFilterButtonPressed: onTraitFilterPressed,
        onSkillFilterButtonPressed: onSkillFilterPressed,
        onSidebarFutureChange: (SidebarFutureTypes type) {
          setState(() {
            if (type == SidebarFutureTypes.TRAITS &&
                sidebarContent == SidebarFutureTypes.TRAITS) {
              selectedTraitCategory = TraitCategories.NONE;
              return;
            }

            sidebarContent = type;
          });
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: APP_BAR_HEIGHT,
        title: Text(
          'points ${characterProvider.character.remainingPoints}/${characterProvider.character.points}',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              int? newPoints = await showDialog<int?>(
                context: context,
                builder: (context) => EditCharacterPointsDialog(
                  currentPoints: characterProvider.character.points,
                ),
              );

              if (newPoints == null) {
                return;
              }

              characterProvider.updateCharacterMaxPoints(newPoints);
            },
            icon: const Icon(
              Icons.monetization_on_outlined,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.SETTINGS.destination);
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          ),
          if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH)
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.now_widgets_outlined),
                onPressed: () => _toggleSidebar(context),
              );
            }),
          if (MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH) Container()
        ],
      ),
      floatingActionButton: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
          ? null
          : Builder(builder: (context) {
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
          basicInfoFields: const ComposePageBasicInfoFields(),
          characterStats: const ComposePageCharacterAttributesSection(),
          traits: ComposePageTraitsView(
            emptyListBuilder: _generateEmptyTraitOrSkillView,
          ),
          skillsAndMagic: ComposePageSkillAndMagicSection(
            emptyListBuilder: _generateEmptyTraitOrSkillView,
          ),
          handWeapons: const ComposePageHandWeaponsSection(),
          rangedWeapons: const ComposePageRangedWeaponsSection(),
          armor: const ComposePageArmorSection(),
          // restOfTheBody: const [],
        ),
      ),
      endDrawer: MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH
          ? null
          : Drawer(
              child: sidebar,
            ),
    );
  }

  void onTraitFilterPressed(TraitCategories category) {
    setState(() {
      sidebarContent = SidebarFutureTypes.TRAITS;

      if (selectedTraitCategory == category) {
        selectedTraitCategory = TraitCategories.NONE;
        return;
      }

      selectedTraitCategory = category;
    });
  }

  void onSkillFilterPressed(SkillDifficulty category) {
    setState(() {
      sidebarContent = SidebarFutureTypes.SKILLS;

      if (selectedSkillDifficulty == category) {
        selectedSkillDifficulty = SkillDifficulty.NONE;
        return;
      }

      selectedSkillDifficulty = category;
    });
  }

  Widget _generateEmptyTraitOrSkillView(List<String> categories) {
    final String types = categories.join('/');

    SidebarFutureTypes contentType = SidebarFutureTypes.TRAITS;

    if (categories.first.toLowerCase() == 'skills') {
      contentType = SidebarFutureTypes.SKILLS;
    }

    if (categories.first.toLowerCase() == 'spells') {
      contentType = SidebarFutureTypes.MAGIC;
    }

    return Column(
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
                _toggleSidebar(
                  context,
                  content: contentType,
                );
              },
              icon: const Icon(Icons.add),
            );
          }),
        ),
      ],
    );
  }
}
