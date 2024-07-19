import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/skills/skill_difficulty.dart';
import 'package:gurps_character_creation/models/skills/skill_stat.dart';

class SkillView extends StatelessWidget {
  final Skill skill;
  const SkillView({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0x64000000), width: 1.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
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
                if (skill.investedPoints > 0)
                  Text(
                    'points: ${skill.investedPoints} (${skill.associatedStat.stringValue}/${skill.difficulty.stringValue})',
                  )
                else
                  Text(
                    'cost: ${skill.basePoints} (${skill.associatedStat.stringValue}/${skill.difficulty.stringValue})',
                  ),
              ],
            ),
            Row(
              children: [
                Text(
                  skill.categories.map((e) => e).join(', '),
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
