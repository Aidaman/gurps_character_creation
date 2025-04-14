import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/utilities/dialog_shape.dart';

class PossessionDetailsDialog extends StatelessWidget {
  final Possession possession;
  const PossessionDetailsDialog({super.key, required this.possession});

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(possession.name),
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

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Price: ${possession.price}',
              ),
            ),
          ],
        ),
        const Gap(8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Weight: ${possession.weight}',
              ),
            ),
          ],
        ),
        if (possession.description.isNotEmpty) const Gap(8),
        if (possession.description.isNotEmpty) _buildSeparator(),
        if (possession.description.isNotEmpty) const Gap(8),
        if (possession.description.isNotEmpty)
          Row(
            children: [
              Expanded(
                child: Text(
                  possession.description,
                ),
              ),
            ],
          )
      ],
    );
  }
}
