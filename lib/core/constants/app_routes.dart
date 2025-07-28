import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character_setup/pages/setup.dart';
import 'package:gurps_character_creation/features/settings/pages/settings.dart';
import 'package:gurps_character_creation/features/character_editor/pages/character_editor.dart';
import 'package:gurps_character_creation/pages/homepage.dart';

enum AppRoutes {
  HOMEPAGE,
  SETUP,
  COMPOSE,
  SETTINGS,
  // CHARACTER_REGISTRY,
}

extension Routes on AppRoutes {
  String get name => switch (this) {
        AppRoutes.HOMEPAGE => 'home',
        AppRoutes.SETUP => 'setup',
        AppRoutes.COMPOSE => 'compose',
        AppRoutes.SETTINGS => 'settings',
        // AppRoutes.CHARACTER_REGISTRY => 'characters',
      };

  String get destination => switch (this) {
        AppRoutes.HOMEPAGE => '/',
        AppRoutes.SETUP => '/setup',
        AppRoutes.COMPOSE => '/compose',
        AppRoutes.SETTINGS => '/settings',
        // AppRoutes.CHARACTER_REGISTRY => '/characters',
      };

  IconData get icon => switch (this) {
        AppRoutes.HOMEPAGE => Icons.home,
        AppRoutes.SETUP => Icons.abc,
        AppRoutes.COMPOSE => Icons.create,
        AppRoutes.SETTINGS => Icons.settings,
        // AppRoutes.CHARACTER_REGISTRY => Icons.people_alt_outlined,
      };

  Widget Function(BuildContext) get pageBuilder => switch (this) {
        AppRoutes.HOMEPAGE => (context) => const Homepage(),
        AppRoutes.SETUP => (context) => const SetupPage(),
        AppRoutes.COMPOSE => (context) => const CharacterEditor(),
        AppRoutes.SETTINGS => (context) => const SettingsPage(),
        // AppRoutes.CHARACTER_REGISTRY => throw UnimplementedError(),
      };
}
