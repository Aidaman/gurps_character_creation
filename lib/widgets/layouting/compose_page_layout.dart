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
    return Row(
      children: [
        Expanded(
          child: bodyContent,
        ),
        if (isSidebarVisible &&
            MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH)
          Container(
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0x64eeeeee)))),
            width: MediaQuery.of(context).size.width < 1100
                ? 256
                : MediaQuery.of(context).size.width * 0.32,
            child: sidebarContent,
          ),
      ],
    );
  }
}
