import 'package:flutter/material.dart';
import 'package:gurps_character_creation/pages/settings.dart';
import 'package:gurps_character_creation/pages/setup.dart';
import 'package:gurps_character_creation/pages/compose.dart';
import 'package:gurps_character_creation/pages/homepage.dart';

class RouteName {
  final String name;
  final String destination;
  final IconData iconName;
  final WidgetBuilder pageBuilder;

  RouteName({
    required this.name,
    required this.destination,
    required this.iconName,
    required this.pageBuilder,
  });
}

enum AppRoutes {
  HOMEPAGE,
  SETUP,
  COMPOSE,
  SETTINGS,
}

extension AppRoutesStrings on AppRoutes {
  String get stringValue => switch (this) {
        AppRoutes.HOMEPAGE => 'home',
        AppRoutes.SETUP => 'setup',
        AppRoutes.COMPOSE => 'compose',
        AppRoutes.SETTINGS => 'settings',
      };
}

RouteName getRouteByName(AppRoutes appRoute) {
  return routes.singleWhere(
    (RouteName route) => route.name == appRoute.stringValue,
  );
}

final List<RouteName> routes = [
  RouteName(
    destination: '/',
    name: AppRoutes.HOMEPAGE.stringValue,
    iconName: Icons.home,
    pageBuilder: (context) => const Homepage(),
  ),
  RouteName(
    destination: '/setup',
    name: AppRoutes.SETUP.stringValue,
    iconName: Icons.abc,
    pageBuilder: (context) => const SetupPage(),
  ),
  RouteName(
    destination: '/compose',
    name: AppRoutes.COMPOSE.stringValue,
    iconName: Icons.create,
    pageBuilder: (context) => const ComposePage(),
  ),
  RouteName(
    destination: '/settings',
    name: AppRoutes.SETTINGS.stringValue,
    iconName: Icons.settings,
    pageBuilder: (context) => const SettingsPage(),
  ),
];
