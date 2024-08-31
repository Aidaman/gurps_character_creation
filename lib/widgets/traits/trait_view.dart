import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';

class TraitView extends StatelessWidget {
  final Trait trait;
  final void Function()? onAddClick;
  final void Function()? onRemoveClick;
  final void Function()? onInfoClick;

  const TraitView({
    super.key,
    required this.trait,
    this.onAddClick,
    this.onRemoveClick,
    this.onInfoClick,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle iconButtonStyle = IconButton.styleFrom(
      iconSize: 16,
      padding: const EdgeInsets.all(4),
    );
    const BoxConstraints iconButtonConstraints = BoxConstraints(
      maxHeight: 32,
      maxWidth: 32,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(color: Color(0x64000000), width: 1.0),
          left: BorderSide(
            color: trait.categories.first.colorValue,
            width: 8.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              trait.name,
              style: const TextStyle(fontSize: 16),
            ),
            Row(
              children: [
                Text(
                  trait.categories.map((e) => e.stringValue).join(', '),
                  style: const TextStyle(fontSize: 14),
                ),
                const Text(' | '),
                Text(
                  trait.type,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            Text(
              'points: ${trait.basePoints}',
              style: const TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                if (onAddClick != null)
                  IconButton(
                    onPressed: onAddClick,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.add),
                  ),
                if (onRemoveClick != null)
                  IconButton(
                    onPressed: onRemoveClick,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.remove),
                  ),
                if (onInfoClick != null)
                  IconButton(
                    onPressed: onInfoClick,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.info),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
