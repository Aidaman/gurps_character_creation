import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_modifier.dart';

class TraitView extends StatelessWidget {
  final Trait trait;
  final void Function()? onAddClick;
  final void Function()? onRemoveClick;
  final void Function()? onInfoClick;
  final void Function()? onChangeModifiersClick;
  final void Function()? onChangePlaceholderClick;

  const TraitView({
    super.key,
    required this.trait,
    this.onAddClick,
    this.onRemoveClick,
    this.onInfoClick,
    this.onChangeModifiersClick,
    this.onChangePlaceholderClick,
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
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
          left: BorderSide(
            color: trait.categories.first.colorValue,
            width: 8.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    '${trait.title}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    '${trait.type} ${trait.categories.map((e) => e.stringValue).join(', ')}',
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'base points: ${trait.basePoints}',
                  ),
                ),
                Expanded(
                  child: Text('cost: ${trait.cost}'),
                )
              ],
            ),
            if (trait.selectedModifiers != null &&
                trait.selectedModifiers!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  trait.selectedModifiers!
                      .map((TraitModifier mod) => mod.name)
                      .join(', '),
                ),
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
                if (onChangeModifiersClick != null)
                  IconButton(
                    onPressed: onChangeModifiersClick,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.category_outlined),
                  ),
                if (onChangePlaceholderClick != null)
                  IconButton(
                    onPressed: onChangePlaceholderClick,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.edit_outlined),
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
