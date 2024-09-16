import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character_provider.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/skills/attributes.dart';
import 'package:provider/provider.dart';

class SkillView extends StatelessWidget {
  final Skill skill;
  final void Function()? onAddClick;
  final void Function()? onRemoveClick;
  final bool? isIncluded;

  const SkillView({
    super.key,
    required this.skill,
    this.onAddClick,
    this.onRemoveClick,
    this.isIncluded,
  });

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final ButtonStyle iconButtonStyle = IconButton.styleFrom(
      iconSize: 16,
      padding: const EdgeInsets.all(4),
    );
    const BoxConstraints iconButtonConstraints = BoxConstraints(
      maxHeight: 32,
      maxWidth: 32,
    );

    Widget body = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.onSurface,
            width: 1.0,
          ),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (skill.investedPoints < 1)
                Text(
                  'cost: ${skill.basePoints} (${skill.associatedAttribute.stringValue}/${skill.difficulty.stringValue})',
                )
              else
                _generateSkillCostText(context),
            ],
          ),
          const SizedBox(
            height: 4.0,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.categories.join(', '),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (skill.specialization != null)
                Expanded(
                  child: Text(skill.specialization!),
                ),
            ],
          ),
          Row(
            children: [
              _generateAddRemoveButtons(
                iconButtonStyle,
                iconButtonConstraints,
              ),
              _generateAdjustmentButtons(
                characterProvider,
                iconButtonStyle,
                iconButtonConstraints,
              ),
            ],
          )
        ],
      ),
    );

    return body;
  }

  Expanded _generateAddRemoveButtons(
    ButtonStyle iconButtonStyle,
    BoxConstraints iconButtonConstraints,
  ) {
    return Expanded(
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
              characterProvider.adjustSkillInvestedPoints(skill, 1);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_upward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSkillInvestedPoints(skill, 4);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSkillInvestedPoints(skill, -1);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_downward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () {
              characterProvider.adjustSkillInvestedPoints(skill, -4);
            },
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_down_outlined),
          ),
      ],
    );
  }

  Text _generateSkillCostText(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final int attributeValue =
        characterProvider.character.getAttribute(skill.associatedAttribute);
    final int effectiveSkill = skill.calculateEffectiveSkill(attributeValue);

    if (effectiveSkill < 0) {
      return Text(
        'invested points: ${skill.investedPoints} (${skill.associatedAttribute.stringValue}$effectiveSkill)',
      );
    }

    if (effectiveSkill == 0) {
      return Text(
        'invested points: ${skill.investedPoints} (${skill.associatedAttribute.stringValue})',
      );
    }

    return Text(
      'invested points: ${skill.investedPoints} (${skill.associatedAttribute.stringValue}+$effectiveSkill)',
    );
  }
}
