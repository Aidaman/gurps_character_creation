import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const ResponsiveGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 800) {
        return GridView.count(
          crossAxisCount: MAX_DESKTOP_COLUMNS,
          crossAxisSpacing: DESKTOP_COLUMNS_SPACING,
          children: children,
        );
      } else {
        return ListView.builder(
          itemBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MOBILE_HORIZONTAL_PADDING,
                vertical: MOBILE_VERTICAL_PADDING,
              ),
              // child: ,
            );
          },
        );
      }
    });
  }
}
