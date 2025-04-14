import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_modifier.dart';
import 'package:gurps_character_creation/utilities/dialog_shape.dart';

class TraitView extends StatelessWidget {
  final Trait trait;
  final void Function()? onAddClick;
  final void Function()? onRemoveClick;
  final void Function()? onChangeModifiersClick;
  final void Function()? onChangePlaceholderClick;
  final void Function()? onIncreaseLevel;
  final void Function()? onReduceLevel;

  const TraitView({
    super.key,
    required this.trait,
    this.onAddClick,
    this.onRemoveClick,
    this.onChangeModifiersClick,
    this.onChangePlaceholderClick,
    this.onIncreaseLevel,
    this.onReduceLevel,
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

    return GestureDetector(
      onLongPress: () {
        if (trait.notes.isEmpty) {
          return;
        }

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              trait.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            content: Text(trait.notes),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 4.0),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1.0,
            ),
            left: BorderSide(
              color: trait.category.colorValue,
              width: 8.0,
            ),
          ),
        ),
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
                    trait.placeholder,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Expanded(
                  child: Text(
                    'base points: ${trait.basePoints}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    trait.tags
                        .where(
                          (tag) => !TraitCategories.values.any(
                            (category) =>
                                category.stringValue.toLowerCase() ==
                                tag.toLowerCase(),
                          ),
                        )
                        .join(', '),
                  ),
                ),
                Expanded(
                  child: Text(
                    'cost: ${trait.cost}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
            if (trait.canLevel)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Points Per Level: ${trait.pointsPerLevel}',
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Levels: ${trait.level}',
                    ),
                  ),
                ],
              ),
            if (trait.selectedModifiers.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  trait.selectedModifiers
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
                if (trait.canLevel)
                  Expanded(
                    child: Container(),
                  ),
                if (onIncreaseLevel != null)
                  IconButton(
                    onPressed: onIncreaseLevel,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.arrow_upward),
                  ),
                if (onReduceLevel != null)
                  IconButton(
                    onPressed: onReduceLevel,
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                    icon: const Icon(Icons.arrow_downward),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
