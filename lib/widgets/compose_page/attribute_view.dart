import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class AttributeView extends StatelessWidget {
  final Attributes attribute;
  final int stat;
  final int pointsSpent;

  final void Function() onIncrement;
  final void Function() onDecrement;

  const AttributeView({
    super.key,
    required this.attribute,
    required this.stat,
    required this.pointsSpent,
    required this.onIncrement,
    required this.onDecrement,
  });

  String formatPointsSpent() {
    if (pointsSpent < 0) {
      return '-${pointsSpent.abs().toString().padLeft(pointsSpent <= -100 ? 2 : 3, '0')}';
    }

    return pointsSpent.toString().padLeft(pointsSpent < 100 ? 3 : 0, '0');
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle iconButtonStyle = IconButton.styleFrom(
      iconSize: 16,
      padding: const EdgeInsets.all(4),
      hoverColor: Colors.transparent,
    );
    const BoxConstraints iconButtonConstraints = BoxConstraints(
      maxHeight: 24,
      maxWidth: 24,
    );

    final Widget body = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '${attribute.abbreviatedStringValue}:',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
        Text(
          '$stat',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Courier',
          ),
        ),
        IconButton(
          style: iconButtonStyle,
          constraints: iconButtonConstraints,
          onPressed: onIncrement,
          icon: const Icon(Icons.add),
        ),
        IconButton(
          style: iconButtonStyle,
          constraints: iconButtonConstraints,
          onPressed: onDecrement,
          icon: const Icon(Icons.remove),
        ),
        Text(
          '[${formatPointsSpent()}p]',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Courier',
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );

    if (MediaQuery.of(context).size.width > MIN_DESKTOP_WIDTH ||
        MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: constraints.maxWidth / 2,
            child: Expanded(child: body),
          );
        },
      );
    }
    if (MediaQuery.of(context).size.width < MIN_DESKTOP_WIDTH) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            width: 200,
            child: Expanded(child: body),
          );
        },
      );
    }
    return body;
  }
}
