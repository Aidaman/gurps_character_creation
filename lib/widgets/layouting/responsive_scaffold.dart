import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    final bool isDesktop =
        kIsWeb || MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH;

    return Scaffold(
      appBar: widget.appBar,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
      body: widget.body,
      floatingActionButton: isDesktop ? null : widget.floatingActionButton,
    );
  }
}
