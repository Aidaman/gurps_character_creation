import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:provider/provider.dart';

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

    CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1.0,
          ),
        ),
      ),
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
          const Gap(4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text('Casting Time: ${spell.castingTime}')),
              Expanded(child: Text('Casting Cost: ${spell.castingCost}')),
            ],
          ),
          const Gap(4),
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
          const Gap(4),
          Row(
            children: [
              Expanded(child: Text('Class: ${spell.spellClass}')),
              Expanded(
                  child: _generateSkillCostText(context, characterProvider)),
            ],
          ),
          const Gap(4),
          if (!isAllPrerequisitesSatisfiedOrNull())
            Row(
              children: [
                Expanded(child: _buildPrerequisitesView(context)),
              ],
            ),
          const Gap(4),
          Row(
            children: [
              Expanded(
                child: _buildActions(
                  iconButtonStyle,
                  iconButtonConstraints,
                ),
              ),
              Expanded(
                child: _generateAdjustmentButtons(
                  characterProvider,
                  iconButtonStyle,
                  iconButtonConstraints,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPrerequisitesView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 2,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
      ),
      child: Column(
        children: [
          const Text('This spell requires to also include:'),
          ...spell.unsatisfitedPrerequisitesList!.map(
            (String spellName) => _buildAddPrereqButton(spellName, context),
          )
        ],
      ),
    );
  }

  Widget _buildAddPrereqButton(String spellName, BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              characterProvider.addSpellByName(spellName, context);
            },
            child: Text(spellName),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    ButtonStyle iconButtonStyle,
    BoxConstraints iconButtonConstraints,
  ) {
    return Row(
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
    );
  }

  Widget _generateAdjustmentButtons(
    CharacterProvider characterProvider,
    ButtonStyle iconButtonStyle,
    BoxConstraints iconButtonConstraints,
  ) {
    return Row(
      children: [
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSpellInvestedPoints(spell, 1);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_upward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSpellInvestedPoints(spell, 4);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSpellInvestedPoints(spell, -1);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_downward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSpellInvestedPoints(spell, -4);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_down_outlined),
          ),
      ],
    );
  }

  Text _generateSkillCostText(
      BuildContext context, CharacterProvider characterProvider) {
    final int effectiveSkill = spell.spellEfficiency(
      magery: characterProvider.character.traits.indexWhere(
                (element) => element.name.toLowerCase() == 'magery',
              ) ==
              -1
          ? 0
          : 1,
    );

    if (effectiveSkill < 0) {
      return Text(
        'invested points: ${spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue}$effectiveSkill)',
      );
    }

    if (effectiveSkill == 0) {
      return Text(
        'invested points: ${spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue})',
      );
    }

    return Text(
      'invested points: ${spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue}+$effectiveSkill)',
    );
  }
}
