import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ComposePageResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  // static const double _SEPARATOR_HEIGHT = 1;
  // static const double _SEPARATOR_INDENT = 16;

  const ComposePageResponsiveGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH) {
      return Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: MAX_DESKTOP_CONTENT_WIDTH,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: DESKTOP_HORIZONTAL_PADDING,
            vertical: DESKTOP_VERTICAL_PADDING,
          ),
          child: ListView.separated(
            itemBuilder: (context, index) {
              return children[index];
            },
            separatorBuilder: (context, index) {
              return const Gap(
                DESKTOP_ROWS_SPACING,
              );
            },
            itemCount: children.length,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: MOBILE_HORIZONTAL_PADDING,
        vertical: MOBILE_VERTICAL_PADDING,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index];
      },
    );
  }
}
