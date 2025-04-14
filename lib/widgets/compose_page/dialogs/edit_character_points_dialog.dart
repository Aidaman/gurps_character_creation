import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';

class EditCharacterPointsDialog extends StatefulWidget {
  final int currentPoints;

  const EditCharacterPointsDialog({
    super.key,
    required this.currentPoints,
  });

  @override
  State<EditCharacterPointsDialog> createState() =>
      _EditCharacterPointsDialogState();
}

class _EditCharacterPointsDialogState extends State<EditCharacterPointsDialog> {
  late int newPoints;

  @override
  void initState() {
    newPoints = widget.currentPoints;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Edit Max Point'),
      shape: dialogShape,
      content: buildTextFormField(
        context: context,
        label: 'Max Points',
        validator: validateNumber,
        onChanged: (String? value) {
          if (value == null) {
            return;
          }

          setState(() {
            newPoints = parseInput(value, int.parse) ?? widget.currentPoints;
          });
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, newPoints);
          },
          child: const Text('confirm'),
        ),
      ],
    );
  }
}
