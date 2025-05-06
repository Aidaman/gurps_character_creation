import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/ranged_weapon.dart';
import 'package:gurps_character_creation/features/equipment/models/weapons/weapon.dart';

class WeaponView extends StatelessWidget {
  final Weapon weapon;
  final void Function()? onAddClick;
  final void Function()? onInfoClick;

  const WeaponView({
    super.key,
    required this.weapon,
    this.onAddClick,
    this.onInfoClick,
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
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 4.0,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      weapon.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const Gap(8),
                    Text(
                      '(${weapon.associatedSkillName})',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Text(
                  'ST: ${weapon.minimumSt.toString()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  weapon.damage.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  '${weapon.weight.toString()}lb',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  _getReachText(weapon),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  '\$${weapon.price.toString()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          if (onAddClick != null || onInfoClick != null)
            Row(
              children: [
                if (onAddClick != null)
                  IconButton(
                    onPressed: onAddClick,
                    icon: const Icon(Icons.add_outlined),
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                  ),
                if (onInfoClick != null)
                  IconButton(
                    onPressed: onInfoClick,
                    icon: const Icon(Icons.info_outline),
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                  ),
              ],
            )
        ],
      ),
    );
  }

  String _getReachText(Weapon weapon) {
    if (weapon is HandWeapon) {
      return 'Reach: ${weapon.reach.toString()}';
    }

    if (weapon is RangedWeapon) {
      return 'Range: ${weapon.range.toString()}';
    }

    return 'C';
  }
}
