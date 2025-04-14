import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/gear/gear.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/gear_editor_dialog.dart';

class PossessionEditorDialog extends StatefulWidget {
  final Possession? oldPossession;
  const PossessionEditorDialog({super.key, this.oldPossession});

  @override
  State<PossessionEditorDialog> createState() => _PossessionEditorDialogState();
}

class _PossessionEditorDialogState extends State<PossessionEditorDialog> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late Possession _posession;

  @override
  void initState() {
    _posession = widget.oldPossession ?? Possession.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GearEditorDialog(
      oldGear: _posession,
      formKey: _formkey,
      actions: [
        TextButton.icon(
          onPressed: () {
            Navigator.pop(context, null);
          },
          label: const Text('cancel'),
        ),
        FilledButton.icon(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Navigator.pop(context, _posession);
            }
          },
          label: const Text('add'),
        ),
      ],
      additionalChildren: [
        buildTextFormField(
          maxLines: null,
          defaultValue: widget.oldPossession?.description,
          label: 'Notes for this Possession',
          keyboardType: TextInputType.multiline,
          validator: (String? value) {
            return null;
          },
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _posession = Possession.copyWith(_posession, description: value);
            });
          },
          context: context,
        ),
      ],
      onGearUpdated: (Gear updatedGear) {
        setState(() {
          _posession = updatedGear as Possession;
        });
      },
    );
  }
}
