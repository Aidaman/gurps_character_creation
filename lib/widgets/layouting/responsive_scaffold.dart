import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveScaffold extends StatefulWidget {
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final int selectedIndex;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.drawer,
    this.endDrawer,
    required this.selectedIndex,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  void _onItemTapped(int index) {
    Navigator.pushNamed(context, routes[index].destination);
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
        elevation: 4,
        indicatorColor: Colors.red[800],
        useIndicator: true,
        labelType: NavigationRailLabelType.all,
        backgroundColor: Colors.grey[100],
        unselectedIconTheme: const IconThemeData(color: Colors.black),
        unselectedLabelTextStyle: const TextStyle(color: Colors.black),
        selectedIconTheme: const IconThemeData(color: Colors.white),
        selectedLabelTextStyle: TextStyle(color: Colors.red[800]),
      ),
      widget.body
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        kIsWeb || MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[900],
      ),
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
              unselectedIconTheme: const IconThemeData(color: Colors.black),
              selectedIconTheme: IconThemeData(color: Colors.red[800]),
              elevation: 4,
              backgroundColor: Colors.grey[100],
              unselectedLabelStyle: const TextStyle(color: Colors.black),
              selectedLabelStyle: TextStyle(color: Colors.red[800]),
            ),
    );
  }
}
