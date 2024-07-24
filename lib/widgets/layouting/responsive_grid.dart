import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH) {
      return GridView.count(
        crossAxisCount: MAX_DESKTOP_COLUMNS,
        crossAxisSpacing: DESKTOP_COLUMNS_SPACING,
        children: children,
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
