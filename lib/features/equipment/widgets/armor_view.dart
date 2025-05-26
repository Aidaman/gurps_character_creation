import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/equipment/models/armor.dart';
import 'package:gurps_character_creation/features/equipment/models/legality_class.dart';

class ArmorView extends StatelessWidget {
  final Armor armor;
  final void Function(Armor armor)? onAddClick;
  final void Function(Armor armor)? onInfoClick;

  const ArmorView({
    super.key,
    required this.armor,
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
                child: Text(
                  armor.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Expanded(
                child: Text(
                  'DR: ${armor.damageResistance.GURPSNotation}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  armor.weight.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  '\$${armor.price.toString()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  armor.armorLocation.map((e) => e.name).join(', '),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Expanded(
                child: Text(
                  armor.lc.stringValue,
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
                    icon: const Icon(Icons.add),
                    onPressed: () => onAddClick?.call(armor),
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                  ),
                if (onInfoClick != null)
                  IconButton(
                    icon: const Icon(Icons.info_outline),
                    onPressed: () => onInfoClick?.call(armor),
                    style: iconButtonStyle,
                    constraints: iconButtonConstraints,
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
