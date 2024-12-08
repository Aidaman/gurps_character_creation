import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/gear/ranged_weapon.dart';
import 'package:gurps_character_creation/utilities/dialog_size.dart';

class RangedWeaponDetailsDialog extends StatelessWidget {
  final RangedWeapon rw;
  const RangedWeaponDetailsDialog({super.key, required this.rw});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(rw.name),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: ConstrainedBox(
        constraints: defineDialogConstraints(context),
        child: SingleChildScrollView(
          child: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Price: ${rw.price}',
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weight: ${rw.weight}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Damage: ${rw.damage}',
                ),
              ),
            ],
          ),
          Text(
            '\nDamage is calculated used from Damage Table, using either Swing or Thrust according to the ST of the character\n\nOften weapons in GURPS also feature an Adds value a positive number or zero, as a modifier to the damage throw\n\nWeapons have their damage type, i.e. Impaling, Crushing or Toxic',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Minimum ST: ${rw.minimumSt}',
                ),
              ),
            ],
          ),
          Text(
            '\nA character can use any weapon they like, but if their ST is less than weapon\'s Minimum St they will have penalty that calculated as Character St - Weapon Min St.\n\nFor example if a weapon require ST 12 at minimum, and character has 10 ST then penalty would be -2',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Associated Skill: ${rw.associatedSkillName}',
                ),
              ),
            ],
          ),
          Text(
            '\nAny weapon has a skill associated with it. Spears is associated with Polearms, Maces associated with Axe/Mace\n\nThe skills determine proficiency with a weapon and how easy it is to use for character, also the parry calculates directly from skill level',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'range: ${rw.range}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'accuracy: ${rw.accuracy}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'rate of fire: ${rw.rateOfFire}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'bulk: ${rw.bulk}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'legality class: ${rw.lc.stringValue}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'recoil: ${rw.recoil}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'shots: ${rw.shots}',
                ),
              ),
            ],
          ),
          _buildSeparator(),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ST: ${rw.st}',
                ),
              ),
            ],
          ),
          if (rw.notes.isNotEmpty) const Gap(8),
          if (rw.notes.isNotEmpty)
            const Divider(
              endIndent: 16,
              indent: 16,
            ),
          if (rw.notes.isNotEmpty) const Gap(8),
          if (rw.notes.isNotEmpty)
            Row(
              children: [
                Expanded(
                  child: Text(
                    rw.notes,
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }

  Column _buildSeparator() {
    return const Column(
      children: [
        Gap(8),
        Divider(
          endIndent: 16,
          indent: 16,
        ),
        Gap(8),
      ],
    );
  }

  List<Widget>? _buildActions(BuildContext context) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context, null);
        },
        label: const Text('exit'),
      ),
    ];
  }
}
