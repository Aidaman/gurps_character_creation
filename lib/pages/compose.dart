import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/common_constants.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/skills/models/skill_difficulty.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:gurps_character_creation/features/character/providers/attributes_provider.dart';
import 'package:gurps_character_creation/features/character/services/attributes_service.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';
import 'package:gurps_character_creation/features/character/providers/personal_info_provider.dart';
import 'package:gurps_character_creation/features/skills/providers/skill_provider.dart';
import 'package:gurps_character_creation/features/skills/services/skill_service.dart';
import 'package:gurps_character_creation/features/spells/providers/spells_provider.dart';
import 'package:gurps_character_creation/features/spells/services/spells_serivce.dart';
import 'package:gurps_character_creation/features/traits/providers/traits_provider.dart';
import 'package:gurps_character_creation/features/traits/services/traits_service.dart';
import 'package:gurps_character_creation/providers/compose_page_sidebar_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/armor_provider.dart';
import 'package:gurps_character_creation/features/gear/services/armor_service.dart';
import 'package:gurps_character_creation/features/gear/providers/possessions_provider.dart';
import 'package:gurps_character_creation/features/gear/services/possessions_service.dart';
import 'package:gurps_character_creation/features/gear/providers/weapon_provider.dart';
import 'package:gurps_character_creation/features/character/services/personal_info_service.dart';
import 'package:gurps_character_creation/features/gear/services/weapon_service.dart';
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
import 'package:gurps_character_creation/widgets/compose_page/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/compose_page/compose_page_responsive_grid.dart';
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
    final characterProvider = context.watch<CharacterProvider>();

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
          SidebarSaveLoadTab(
            characterIOService: CharacterIOService(),
          ),
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
        ),
        ChangeNotifierProvider(
          create: (_) => AttributesProvider(
            characterProvider,
            CharacterAttributesService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TraitsProvider(
            characterProvider,
            CharacterTraitsService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SkillsProvider(
            characterProvider,
            CharacterSkillsService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SpellsProvider(
            characterProvider,
            CharacterSpellsSerivce(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ArmorProvider(
            characterProvider,
            ArmorService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PossessionsProvider(
            characterProvider,
            PossessionsService(),
          ),
        ),
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
                  personalInfoProvider: context.watch<PersonalInfoProvider>(),
                ),
                AttributesSection(
                  attributesProvider: context.watch<AttributesProvider>(),
                ),
                TraitsSection(
                  emptyListBuilder: (categories) =>
                      _generateEmptyTraitOrSkillView(
                    categories,
                    sidebarProvider,
                  ),
                  traitsProvider: context.watch<TraitsProvider>(),
                ),
                SkillsSection(
                  emptyListBuilder: (categories) =>
                      _generateEmptyTraitOrSkillView(
                    categories,
                    sidebarProvider,
                  ),
                  skillsProvider: context.watch<SkillsProvider>(),
                  spellsProvider: context.watch<SpellsProvider>(),
                ),
                MeleeWeaponsSection(
                  character: characterProvider.character,
                  weaponProvider: context.watch<CharacterWeaponProvider>(),
                ),
                RangedWeaponsSection(
                  weaponProvider: context.watch<CharacterWeaponProvider>(),
                ),
                ArmorSection(
                  armorProvider: context.watch<ArmorProvider>(),
                ),
                PosessionsSection(
                  possessionsProvider: context.watch<PossessionsProvider>(),
                ),
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
