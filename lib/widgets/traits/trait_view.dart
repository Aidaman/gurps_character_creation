import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';

class TraitView extends StatelessWidget {
  final Trait trait;
  const TraitView({super.key, required this.trait});

  @override
  Widget build(BuildContext context) {
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
            Row(
              children: [
                Expanded(
                  child: Text(
                    trait.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  trait.categories.map((e) => e.stringValue).join(', '),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trait.type,
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  'points: ${trait.basePoints}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
