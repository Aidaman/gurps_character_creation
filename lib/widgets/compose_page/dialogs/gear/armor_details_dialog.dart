import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';

class ArmorDetailsDialog extends StatelessWidget {
  final Armor armor;

  const ArmorDetailsDialog({super.key, required this.armor});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(armor.name),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: SingleChildScrollView(
        child: _buildBody(context),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context, null);
        },
        label: const Text('exit'),
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Price: ${armor.price}',
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Weight: ${armor.weight}',
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Resistance: ${armor.damageResistance.damageResistance}',
                ),
              ),
            ],
          ),
          const Gap(8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${armor.notes}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
