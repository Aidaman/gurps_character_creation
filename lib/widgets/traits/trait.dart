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
        color: const Color(0xFFfdfdfd),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 4),
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
                Expanded(
                  child: Text(
                    'type: ${trait.type}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    'points: ${trait.basePoints}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
                Expanded(
                  child: Text(
                    'categories: ${trait.categories.map(
                      (e) => e.stringValue,
                    )}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
