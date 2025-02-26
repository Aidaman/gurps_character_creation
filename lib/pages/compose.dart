import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/character/personal_info_provider.dart';
import 'package:gurps_character_creation/providers/compose_page_sidebar_provider.dart';
import 'package:gurps_character_creation/providers/gear/weapon_provider.dart';
import 'package:gurps_character_creation/services/character/personal_info_service.dart';
import 'package:gurps_character_creation/services/gear/weapon_service.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/armor_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/personal_info_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/attributes_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/melee_weapons.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/possessions_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/ranged_weapons_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/skills_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sections/traits_section.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar/sidebar.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar/sidebar_aspects_tab.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar/sidebar_save_load_tab.dart';
import 'package:gurps_character_creation/widgets/compose_page/sidebar/sidebar_settings.dart';
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

  TraitCategories selectedTraitCategory = TraitCategories.NONE;
  SkillDifficulty selectedSkillDifficulty = SkillDifficulty.NONE;
  SidebarFutureTypes sidebarContent = SidebarFutureTypes.TRAITS;

  void _toggleSidebar(
    BuildContext context,
    ComposePageSidebarProvider sidebarProvider, {
    SidebarFutureTypes? content,
  }) {
    if (content != null) {
      setState(() {
        sidebarContent = content;
      });
    }

    sidebarProvider.toggleSidebar(context);
  }

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final bool isDesktop =
        MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH;

    final Widget sidebar = SafeArea(
      child: Sidebar(
        actions: const [
          Icons.widgets_outlined,
          Icons.save,
          Icons.settings_outlined,
        ],
        tabs: [
          SidebarAspectsTab(
            selectedSkillDifficulty: selectedSkillDifficulty,
            selectedTraitCategory: selectedTraitCategory,
            content: sidebarContent,
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
          const SidebarSaveLoadTab(),
          const SidebarSettingsTab(),
        ],
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ComposePageSidebarProvider>(
          create: (_) => ComposePageSidebarProvider(),
        ),
        ChangeNotifierProvider<CharacterWeaponProvider>(
          create: (_) => CharacterWeaponProvider(
            characterProvider,
            WeaponService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PersonalInfoProvider(
            characterProvider,
            CharacterPersonalInfoService(),
          ),
        )
      ],
      builder: (context, child) {
        final ComposePageSidebarProvider sidebarProvider =
            Provider.of<ComposePageSidebarProvider>(context);

        return Scaffold(
          appBar: AppBar(
            toolbarHeight: APP_BAR_HEIGHT,
            centerTitle: true,
            title: Text(
              'points ${characterProvider.character.remainingPoints}/${characterProvider.character.points}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            actions: [Container()],
          ),
          floatingActionButton: !isDesktop
              ? Builder(
                  builder: (context) => FloatingActionButton(
                    onPressed: () => _toggleSidebar(context, sidebarProvider),
                    child: const Icon(Icons.now_widgets_outlined),
                  ),
                )
              : null,
          endDrawer: !isDesktop
              ? Drawer(
                  child: sidebar,
                )
              : null,
          body: ComposePageLayout(
            sidebarContent: sidebar,
            bodyContent: ComposePageResponsiveGrid(
              children: [
                PersonalInfoSection(
                  personalInfoProvider:
                      Provider.of<PersonalInfoProvider>(context),
                ),
                const AttributesSection(),
                TraitsSection(
                  emptyListBuilder: (categories) =>
                      _generateEmptyTraitOrSkillView(
                    categories,
                    sidebarProvider,
                  ),
                ),
                SkillsSection(
                  emptyListBuilder: (categories) =>
                      _generateEmptyTraitOrSkillView(
                    categories,
                    sidebarProvider,
                  ),
                ),
                MeleeWeaponsSection(
                  character: characterProvider.character,
                  weaponProvider: Provider.of<CharacterWeaponProvider>(context),
                ),
                RangedWeaponsSection(
                  character: characterProvider.character,
                  weaponProvider: Provider.of<CharacterWeaponProvider>(context),
                ),
                const ArmorSection(),
                const PosessionsSection(),
              ],
            ),
          ),
        );
      },
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

  Widget _generateEmptyTraitOrSkillView(
    List<String> categories,
    ComposePageSidebarProvider sidebarProvider,
  ) {
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
                  sidebarProvider,
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
