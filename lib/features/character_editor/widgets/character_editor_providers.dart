import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/providers/attributes_provider.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/providers/personal_info_provider.dart';
import 'package:gurps_character_creation/features/character/services/attributes_service.dart';
import 'package:gurps_character_creation/features/character/services/personal_info_service.dart';
import 'package:gurps_character_creation/features/gear/providers/armor_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/possessions_provider.dart';
import 'package:gurps_character_creation/features/gear/providers/weapon_provider.dart';
import 'package:gurps_character_creation/features/gear/services/armor_service.dart';
import 'package:gurps_character_creation/features/gear/services/possessions_service.dart';
import 'package:gurps_character_creation/features/gear/services/weapon_service.dart';
import 'package:gurps_character_creation/features/skills/providers/skill_provider.dart';
import 'package:gurps_character_creation/features/skills/services/skill_service.dart';
import 'package:gurps_character_creation/features/spells/providers/spells_provider.dart';
import 'package:gurps_character_creation/features/spells/services/spells_serivce.dart';
import 'package:gurps_character_creation/features/traits/providers/traits_provider.dart';
import 'package:gurps_character_creation/features/traits/services/traits_service.dart';
import 'package:gurps_character_creation/providers/compose_page_sidebar_provider.dart';
import 'package:provider/provider.dart';

class CharacterEditorProviders extends StatelessWidget {
  final CharacterProvider _characterProvider;
  final Widget Function(BuildContext, Widget?) _builder;

  const CharacterEditorProviders({
    super.key,
    required Widget Function(BuildContext, Widget?) builder,
    required CharacterProvider characterProvider,
  })  : _characterProvider = characterProvider,
        _builder = builder;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ComposePageSidebarProvider>(
          create: (_) => ComposePageSidebarProvider(),
        ),
        ChangeNotifierProvider<CharacterWeaponProvider>(
          create: (_) => CharacterWeaponProvider(
            _characterProvider,
            WeaponService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PersonalInfoProvider(
            _characterProvider,
            CharacterPersonalInfoService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AttributesProvider(
            _characterProvider,
            CharacterAttributesService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TraitsProvider(
            _characterProvider,
            CharacterTraitsService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SkillsProvider(
            _characterProvider,
            CharacterSkillsService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SpellsProvider(
            _characterProvider,
            CharacterSpellsSerivce(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ArmorProvider(
            _characterProvider,
            ArmorService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PossessionsProvider(
            _characterProvider,
            PossessionsService(),
          ),
        ),
      ],
      builder: _builder,
    );
  }
}
