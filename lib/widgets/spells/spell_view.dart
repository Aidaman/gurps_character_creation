import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/providers/character/aspects_provider.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/providers/character/spells_provider.dart';
import 'package:provider/provider.dart';

class SpellView extends StatefulWidget {
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

  @override
  State<SpellView> createState() => _SpellViewState();
}

class _SpellViewState extends State<SpellView> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isIncluded == true;
  }

  bool isAllPrerequisitesSatisfiedOrNull() {
    bool prerequisitesIsNull =
        widget.spell.unsatisfitedPrerequisitesList == null;

    return prerequisitesIsNull ||
        !prerequisitesIsNull &&
            widget.spell.unsatisfitedPrerequisitesList!.isEmpty;
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

    return GestureDetector(
      onTap: () {
        setState(() {
          if (widget.isIncluded != null && widget.isIncluded!) {
            _isExpanded = !_isExpanded;
          }
        });
      },
      child: Container(
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
                    widget.spell.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                Expanded(
                  child: Text(widget.spell.college.join(', ')),
                ),
              ],
            ),
            if (_isExpanded) const Gap(4),
            if (_isExpanded)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: Text('Casting Time: ${widget.spell.castingTime}')),
                  Expanded(
                      child: Text('Casting Cost: ${widget.spell.castingCost}')),
                ],
              ),
            if (_isExpanded) const Gap(4),
            if (_isExpanded)
              Row(
                children: [
                  Expanded(
                    child: Text('Duration: ${widget.spell.duration}'),
                  ),
                  Expanded(
                    child: Text(
                        'Maintanence cost: ${widget.spell.maintenanceCost}'),
                  ),
                ],
              ),
            const Gap(4),
            Row(
              children: [
                Expanded(child: Text('Class: ${widget.spell.spellClass}')),
                Expanded(
                    child: _generateSkillCostText(context, characterProvider)),
              ],
            ),
            const Gap(4),
            if (!isAllPrerequisitesSatisfiedOrNull() && _isExpanded)
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
                    context,
                  ),
                ),
              ],
            )
          ],
        ),
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
          ...widget.spell.unsatisfitedPrerequisitesList!.map(
            (String spellName) => _buildAddPrereqButton(spellName, context),
          )
        ],
      ),
    );
  }

  Widget _buildAddPrereqButton(String spellName, BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () {
              context.read<SpellsProvider>().addByName(
                    spellName,
                    context.read<AspectsProvider>(),
                  );
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
        if (widget.onAddClick != null)
          IconButton(
            onPressed: widget.onAddClick,
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.add),
          ),
        if (widget.onRemoveClick != null)
          IconButton(
            onPressed: widget.onRemoveClick,
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
    BuildContext context,
  ) {
    return Row(
      children: [
        if (widget.isIncluded == true)
          IconButton(
            onPressed: () {
              context.read<SpellsProvider>().updateSpellLevel(
                    widget.spell,
                    doIncrease: true,
                    points: 1,
                  );
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_upward),
          ),
        if (widget.isIncluded == true)
          IconButton(
            onPressed: () {
              context.read<SpellsProvider>().updateSpellLevel(
                    widget.spell,
                    doIncrease: true,
                    points: 4,
                  );
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
          ),
        if (widget.isIncluded == true)
          IconButton(
            onPressed: () {
              context.read<SpellsProvider>().updateSpellLevel(
                    widget.spell,
                    doIncrease: false,
                    points: 1,
                  );
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_downward),
          ),
        if (widget.isIncluded == true)
          IconButton(
            onPressed: () {
              context.read<SpellsProvider>().updateSpellLevel(
                    widget.spell,
                    doIncrease: false,
                    points: 4,
                  );
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
    final int mageryIndex = characterProvider.character.traits.indexWhere(
      (element) => element.name.toLowerCase() == 'magery',
    );

    int effectiveSkill = mageryIndex == -1
        ? widget.spell.spellEfficiency(mageryLevel: 0)
        : widget.spell.spellEfficiency(
            mageryLevel: characterProvider.character.traits[mageryIndex].level,
          );

    if (effectiveSkill < 0) {
      return Text(
        'invested points: ${widget.spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue}$effectiveSkill)',
      );
    }

    if (effectiveSkill == 0) {
      return Text(
        'invested points: ${widget.spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue})',
      );
    }

    return Text(
      'invested points: ${widget.spell.investedPoints} (${Attributes.IQ.abbreviatedStringValue}+$effectiveSkill)',
    );
  }
}
