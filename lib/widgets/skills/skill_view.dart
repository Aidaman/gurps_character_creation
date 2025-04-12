import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/services/character/providers/skill_provider.dart';
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
    final ButtonStyle iconButtonStyle = IconButton.styleFrom(
      iconSize: 16,
      padding: const EdgeInsets.all(4),
    );
    const BoxConstraints iconButtonConstraints = BoxConstraints(
      maxHeight: 32,
      maxWidth: 32,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.0,
            color: Theme.of(context).colorScheme.secondary,
          ),
          left: BorderSide(
            color: skill.difficulty.colorValue,
            width: 8.0,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (skill.investedPoints < 1)
                Expanded(
                  child: Text(
                    'cost: ${skill.basePoints} (${skill.associatedAttribute.abbreviatedStringValue}/${skill.difficulty.stringValue})',
                  ),
                )
              else
                _generateSkillCostText(context),
            ],
          ),
          const Gap(4.0),
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
              _generateActions(
                iconButtonStyle,
                iconButtonConstraints,
              ),
              _generateAdjustmentButtons(
                Provider.of<SkillsProvider>(context),
                iconButtonStyle,
                iconButtonConstraints,
              ),
            ],
          )
        ],
      ),
    );
  }

  Expanded _generateActions(
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
    SkillsProvider skillsProvider,
    ButtonStyle iconButtonStyle,
    BoxConstraints iconButtonConstraints,
  ) {
    return Row(
      children: [
        if (isIncluded == true)
          IconButton(
            onPressed: () => skillsProvider.updateSkillLevel(skill, 1),
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_upward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () => skillsProvider.updateSkillLevel(skill, 4),
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_up_outlined),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () => skillsProvider.updateSkillLevel(skill, -1),
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.arrow_downward),
          ),
        if (isIncluded == true)
          IconButton(
            onPressed: () => skillsProvider.updateSkillLevel(skill, -4),
            style: iconButtonStyle,
            constraints: iconButtonConstraints,
            icon: const Icon(Icons.keyboard_double_arrow_down_outlined),
          ),
      ],
    );
  }

  Text _generateSkillCostText(BuildContext context) {
    final int effectiveSkill = skill.skillEfficiency;

    if (effectiveSkill < 0) {
      return Text(
        'invested points: ${skill.investedPoints} (${skill.associatedAttribute.abbreviatedStringValue}$effectiveSkill)',
      );
    }

    if (effectiveSkill == 0) {
      return Text(
        'invested points: ${skill.investedPoints} (${skill.associatedAttribute.abbreviatedStringValue})',
      );
    }

    return Text(
      'invested points: ${skill.investedPoints} (${skill.associatedAttribute.abbreviatedStringValue}+$effectiveSkill)',
    );
  }
}
