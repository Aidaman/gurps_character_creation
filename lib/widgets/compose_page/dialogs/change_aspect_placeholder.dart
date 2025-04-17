import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';

class ChangeAspectPlaceholderNameDialog extends StatefulWidget {
  final String placeholder;

  const ChangeAspectPlaceholderNameDialog({
    super.key,
    required this.placeholder,
  });

  @override
  State<ChangeAspectPlaceholderNameDialog> createState() =>
      ChangeAspectPlaceholderNameDialogState();
}

class ChangeAspectPlaceholderNameDialogState
    extends State<ChangeAspectPlaceholderNameDialog> {
  String? updatedPlaceholder;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(
        widget.placeholder,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      actions: _buildActions(context),
      content: Expanded(
          child: buildTextFormField(
        label: widget.placeholder,
        validator: validateText,
        onChanged: (String? value) => setState(() {
          updatedPlaceholder = value;
        }),
        context: context,
      )),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      FilledButton.icon(
        onPressed: () {
          Navigator.pop(
            context,
            updatedPlaceholder,
          );
        },
        label: const Text('add'),
      ),
    ];
  }
}
