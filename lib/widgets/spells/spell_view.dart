import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/spells/spell.dart';

class SpellView extends StatelessWidget {
  final Spell spell;
  final void Function()? onAddClick;
  final void Function()? onRemoveClick;
  final bool? isIncluded;

  const SpellView({
    super.key,
    required this.spell,
    this.onAddClick,
    this.onRemoveClick,
    this.isIncluded,
  });

  bool isAllPrerequisitesSatisfiedOrNull() {
    bool prerequisitesIsNull = spell.unsatisfitedPrerequisitesList == null;
    return prerequisitesIsNull ||
        !prerequisitesIsNull && spell.unsatisfitedPrerequisitesList!.isEmpty;
  }

  Color determineBottomBorderColor(BuildContext context) {
    if (isAllPrerequisitesSatisfiedOrNull()) {
      return Theme.of(context).colorScheme.onSurface;
    }

    return Theme.of(context).colorScheme.error;
  }

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

    Widget body = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: determineBottomBorderColor(context),
            width: isAllPrerequisitesSatisfiedOrNull() ? 1.0 : 2.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    spell.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(spell.college.join(', ')),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text('Casting Time: ${spell.castingTime}')),
                Expanded(child: Text('Casting Cost: ${spell.castingCost}')),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text('Duration: ${spell.duration}'),
                ),
                Expanded(
                  child: Text('Maintanence cost: ${spell.maintenanceCost}'),
                ),
              ],
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [Text('Class: ${spell.spellClass}')],
            ),
            if (onAddClick != null || onRemoveClick != null)
              Column(
                children: [
                  const SizedBox(
                    height: 4,
                  ),
                  _generateIncludeButtons(
                    iconButtonStyle,
                    iconButtonConstraints,
                  ),
                ],
              )
          ],
        ),
      ),
    );

    if (isAllPrerequisitesSatisfiedOrNull()) {
      return body;
    }

    return Column(
      children: [
        body,
        Text('The \'${spell.name}\' requires you to include these spells:'),
        ...spell.unsatisfitedPrerequisitesList!.map(
          (e) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    e,
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            );
          },
        )
      ],
    );
  }

  Row _generateIncludeButtons(
      ButtonStyle iconButtonStyle, BoxConstraints iconButtonConstraints) {
    return Row(
      children: [
        Expanded(
          child: Row(
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
            ],
          ),
        )
      ],
    );
  }
}
