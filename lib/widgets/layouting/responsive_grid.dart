import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveGrid({super.key, required this.children});

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
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MAX_TABLET_COLUMNS,
              crossAxisSpacing: DESKTOP_COLUMNS_SPACING,
              mainAxisSpacing: DESKTOP_COLUMNS_SPACING,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: MOBILE_HORIZONTAL_PADDING,
              vertical: MOBILE_VERTICAL_PADDING,
            ),
            child: children[index],
          );
        },
      );
    }
  }
}
