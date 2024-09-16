import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ComposePageResponsiveGrid extends StatelessWidget {
  final List<Widget> basicInfoFields;
  final List<Widget> traits;
  final List<Widget> characterStats;
  final List<Widget> skillsAndMagic;
  final List<Widget>? handWeapons;
  final List<Widget>? rangeWeapons;
  final List<Widget>? armor;
  final List<Widget>? posession;
  final List<Widget> restOfTheBody;

  // static const double _SEPARATOR_HEIGHT = 1;
  // static const double _SEPARATOR_INDENT = 16;

  const ComposePageResponsiveGrid({
    super.key,
    required this.basicInfoFields,
    required this.characterStats,
    required this.traits,
    required this.skillsAndMagic,
    required this.restOfTheBody,
    this.handWeapons,
    this.rangeWeapons,
    this.armor,
    this.posession,
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH) {
      final List<List<Widget>> children = [
        basicInfoFields,
        characterStats,
        traits,
        skillsAndMagic,
        restOfTheBody,
      ];

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
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children.elementAt(index),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(
                height: DESKTOP_ROWS_SPACING,
              );
            },
            itemCount: children.length,
          ),
        ),
      );
    } else {
      final List<Widget> children = [
        ...basicInfoFields,
        Wrap(
          alignment: WrapAlignment.spaceEvenly,
          children: characterStats,
        ),
        ...traits,
        ...skillsAndMagic,
        ...restOfTheBody,
      ];

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
