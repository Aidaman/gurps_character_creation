import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ComposePageLayout extends StatelessWidget {
  final Widget sidebarContent;
  final Widget bodyContent;
  final bool isSidebarVisible;

  const ComposePageLayout({
    super.key,
    required this.sidebarContent,
    required this.bodyContent,
    required this.isSidebarVisible,
  });

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = MediaQuery.of(context).size.width * 0.32;

    if (MediaQuery.of(context).size.width < MIN_DESKTOP_WIDTH) {
      sidebarWidth = 256;
    }

    return Row(
      children: [
        Expanded(
          child: bodyContent,
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 512),
          curve: Curves.easeInOut,
          width: isSidebarVisible &&
                  MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
              ? sidebarWidth
              : 0,
          child: sidebarContent,
        ),
      ],
    );
  }
}
