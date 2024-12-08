import 'package:flutter/material.dart';
import 'package:gurps_character_creation/pages/settings.dart';
import 'package:gurps_character_creation/pages/setup.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/pages/compose.dart';
import 'package:gurps_character_creation/pages/homepage.dart';
import 'package:provider/provider.dart';

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

final List<RouteName> routes = [
  RouteName(
    destination: '/',
    name: 'home',
    iconName: Icons.home,
    pageBuilder: (context) => const Homepage(),
  ),
  RouteName(
    destination: '/setup',
    name: 'setup',
    iconName: Icons.abc,
    pageBuilder: (context) => ChangeNotifierProvider(
      create: (_) => CharacterProvider(),
      child: const SetupPage(),
    ),
  ),
  RouteName(
    destination: '/compose',
    name: 'compose',
    iconName: Icons.create,
    pageBuilder: (context) => ChangeNotifierProvider(
      create: (_) => CharacterProvider(),
      child: const ComposePage(),
    ),
  ),
  RouteName(
    destination: '/settings',
    name: 'settings',
    iconName: Icons.settings,
    pageBuilder: (context) => ChangeNotifierProvider(
      create: (_) => CharacterProvider(),
      child: const SettingsPage(),
    ),
  ),
];
