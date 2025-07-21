import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_provider.dart';
import 'package:provider/provider.dart';

class ComposePageLayout extends StatelessWidget {
  final Widget sidebarContent;
  final Widget bodyContent;

  const ComposePageLayout({
    super.key,
    required this.sidebarContent,
    required this.bodyContent,
  });

  @override
  Widget build(BuildContext context) {
    SidebarProvider sidebarProvider = Provider.of<SidebarProvider>(context);

    double sidebarWidth = MediaQuery.of(context).size.width * 0.32;
    bool isDesktop = MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH;

    if (MediaQuery.of(context).size.width < MIN_DESKTOP_WIDTH) {
      sidebarWidth = 256;
    }

    return Row(
      children: [
        Expanded(
          child: bodyContent,
        ),
        if (isDesktop)
          SizedBox(
            width: 64.0,
            child: _buildToggleSidebarButton(sidebarProvider),
          ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 512),
          curve: Curves.easeInOut,
          width:
              sidebarProvider.isSidebarVisible && isDesktop ? sidebarWidth : 0,
          child: sidebarContent,
        ),
      ],
    );
  }

  Widget _buildToggleSidebarButton(SidebarProvider sidebarProvider) {
    bool isHovered = false;

    return StatefulBuilder(builder: (context, setState) {
      ColorScheme theme = Theme.of(context).colorScheme;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Gap(86),
          MouseRegion(
            onEnter: (_) => setState(() => isHovered = true),
            onExit: (_) => setState(() => isHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 128),
              padding: EdgeInsets.only(
                left: 4,
                right: isHovered ? 16 : 4,
                bottom: 4,
                top: 4,
              ),
              decoration: BoxDecoration(
                color: theme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  topLeft: Radius.circular(16),
                ),
              ),
              child: IconButton(
                onPressed: () => sidebarProvider.toggleSidebar(context),
                icon: Icon(
                  color: theme.onPrimary,
                  sidebarProvider.isSidebarVisible
                      ? Icons.close
                      : Icons.widgets_outlined,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
