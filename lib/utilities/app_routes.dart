import 'package:flutter/material.dart';
import 'package:gurps_character_creation/pages/compose.dart';
import 'package:gurps_character_creation/pages/homepage.dart';

class RouteName {
  final String name;
  final String destination;
  final IconData iconName;
  final Widget page;

  RouteName(
      {required this.name,
      required this.destination,
      required this.iconName,
      required this.page});
}

final List<RouteName> routes = [
  RouteName(
    destination: '/',
    name: 'home',
    iconName: Icons.home,
    page: const Homepage(),
  ),
  RouteName(
    destination: '/compose',
    name: 'compose',
    iconName: Icons.create,
    page: const ComposePage(),
  ),
];
