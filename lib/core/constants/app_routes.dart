import 'package:flutter/material.dart';
import 'package:gurps_character_creation/pages/settings.dart';
import 'package:gurps_character_creation/pages/setup.dart';
import 'package:gurps_character_creation/pages/compose.dart';
import 'package:gurps_character_creation/pages/homepage.dart';

enum AppRoutes {
  HOMEPAGE,
  SETUP,
  COMPOSE,
  SETTINGS,
}

extension Routes on AppRoutes {
  String get name => switch (this) {
        AppRoutes.HOMEPAGE => 'home',
        AppRoutes.SETUP => 'setup',
        AppRoutes.COMPOSE => 'compose',
        AppRoutes.SETTINGS => 'settings',
      };

  String get destination => switch (this) {
        AppRoutes.HOMEPAGE => '/',
        AppRoutes.SETUP => '/setup',
        AppRoutes.COMPOSE => '/compose',
        AppRoutes.SETTINGS => '/settings',
      };

  IconData get icon => switch (this) {
        AppRoutes.HOMEPAGE => Icons.home,
        AppRoutes.SETUP => Icons.abc,
        AppRoutes.COMPOSE => Icons.create,
        AppRoutes.SETTINGS => Icons.settings,
      };

  Widget Function(BuildContext) get pageBuilder => switch (this) {
        AppRoutes.HOMEPAGE => (context) => const Homepage(),
        AppRoutes.SETUP => (context) => const SetupPage(),
        AppRoutes.COMPOSE => (context) => const ComposePage(),
        AppRoutes.SETTINGS => (context) => const SettingsPage(),
      };
}
