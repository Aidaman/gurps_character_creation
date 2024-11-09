import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveScaffold extends StatefulWidget {
  final Widget body;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? floatingActionButton;
  final AppBar? appBar;
  final int selectedIndex;

  const ResponsiveScaffold({
    super.key,
    required this.body,
    required this.selectedIndex,
    this.drawer,
    this.endDrawer,
    this.appBar,
    this.floatingActionButton,
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
        minWidth: 64,
        useIndicator: true,
        labelType: NavigationRailLabelType.all,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      Expanded(child: widget.body)
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
      floatingActionButton: isDesktop ? null : widget.floatingActionButton,
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: widget.selectedIndex,
              destinations: routes
                  .map(
                    (e) => NavigationDestination(
                      icon: Icon(e.iconName),
                      label: e.name,
                    ),
                  )
                  .toList(),
              onDestinationSelected: _onItemTapped,
              elevation: COMMON_ELLEVATION,
              indicatorColor: Theme.of(context).colorScheme.primary,
              animationDuration: const Duration(milliseconds: 256),
              height: 64,
              shadowColor: Colors.black,
            ),
    );
  }
}
