import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/common_constants.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/character_editor/widgets/character_editor_providers.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:gurps_character_creation/features/character/providers/attributes_provider.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/providers/personal_info_provider.dart';
import 'package:gurps_character_creation/features/skills/providers/skill_provider.dart';
import 'package:gurps_character_creation/features/spells/providers/spells_provider.dart';
import 'package:gurps_character_creation/features/traits/providers/traits_provider.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/armor_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/possessions_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/weapon_provider.dart';
import 'package:gurps_character_creation/features/character_editor/sections/armor_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/personal_info_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/attributes_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/melee_weapons.dart';
import 'package:gurps_character_creation/features/character_editor/sections/possessions_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/ranged_weapons_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/skills_section.dart';
import 'package:gurps_character_creation/features/character_editor/sections/traits_section.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/sidebar.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/tabs/sidebar_aspects_tab.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/tabs/sidebar_save_load_tab.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/tabs/sidebar_settings.dart';
import 'package:gurps_character_creation/features/character_editor/widgets/compose_page_layout.dart';
import 'package:gurps_character_creation/features/character_editor/widgets/compose_page_responsive_grid.dart';
import 'package:provider/provider.dart';

class CharacterEditor extends StatefulWidget {
  const CharacterEditor({super.key});

  @override
  State<CharacterEditor> createState() => _CharacterEditorState();
}

class _CharacterEditorState extends State<CharacterEditor> {
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
          const SidebarAspectsTab(),
          SidebarSaveLoadTab(
            characterIOService: CharacterIOService(),
          ),
          const SidebarSettingsTab(),
        ],
      ),
    );

    return CharacterEditorProviders(
      characterProvider: characterProvider,
      builder: (context, child) {
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
                    onPressed: () =>
                        context.read<SidebarProvider>().toggleSidebar(context),
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
                  traitsProvider: context.watch<TraitsProvider>(),
                ),
                SkillsSection(
                  skillsProvider: context.watch<SkillsProvider>(),
                  spellsProvider: context.watch<SpellsProvider>(),
                ),
                MeleeWeaponsSection(
                  character: characterProvider.character,
                  weaponProvider: context.watch<CharacterWeaponProvider>(),
                ),
                RangedWeaponsSection(
                  character: characterProvider.character,
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
}
