import 'package:flutter/material.dart';
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

final List<RouteName> routes = [
  RouteName(
    destination: '/',
    name: 'home',
    iconName: Icons.home,
    pageBuilder: (context) => const Homepage(),
  ),
  RouteName(
    destination: '/compose',
    name: 'compose',
    iconName: Icons.create,
    pageBuilder: (context) => ComposePage(
      character: null,
    ),
  ),
];
