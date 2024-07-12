import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveScaffold extends StatefulWidget {
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final AppBar? appBar;
  final int selectedIndex;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    this.drawer,
    this.endDrawer,
    this.appBar,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  void _onItemTapped(int index) {
    Navigator.popAndPushNamed(context, routes[index].destination);
  }

  Widget getBody(BuildContext context) {
    final bool isDesktop =
        kIsWeb || MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH;

    if (!isDesktop) {
      return widget.body;
    }

    return Row(children: [
      NavigationRail(
        destinations: routes
            .map(
              (e) => NavigationRailDestination(
                icon: Icon(e.iconName),
                label: Text(e.name),
              ),
            )
            .toList(),
        onDestinationSelected: _onItemTapped,
        selectedIndex: widget.selectedIndex,
        elevation: COMMON_ELLEVATION,
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        useIndicator: true,
        labelType: NavigationRailLabelType.all,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      widget.body
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        kIsWeb || MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH;

    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      body: getBody(context),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: widget.selectedIndex,
              items: routes
                  .map(
                    (e) => BottomNavigationBarItem(
                      icon: Icon(e.iconName),
                      label: e.name,
                    ),
                  )
                  .toList(),
              onTap: _onItemTapped,
              elevation: COMMON_ELLEVATION,
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedIconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.primary),
              selectedItemColor: Theme.of(context).colorScheme.primary,
            ),
    );
  }
}
