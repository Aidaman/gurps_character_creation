import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/traits/models/trait_modifier.dart';

class TraitModifierView extends StatelessWidget {
  final TraitModifier traitModifier;
  final bool isSelected;
  final void Function(bool?) onChanged;

  const TraitModifierView({
    super.key,
    required this.isSelected,
    required this.onChanged,
    required this.traitModifier,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: isSelected, onChanged: onChanged),
        Expanded(
          child: Text(traitModifier.name),
        ),
        Expanded(
          child: Text('cost: ${traitModifier.cost}p'),
        ),
      ],
    );
  }
}
