import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/equipment/models/equipment.dart';

class EquipmentEditorDialog extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> actions;
  final Equipment oldGear;
  final List<Widget> additionalChildren;
  final ValueChanged<Equipment> onGearUpdated;

  const EquipmentEditorDialog({
    super.key,
    required this.oldGear,
    required this.formKey,
    required this.actions,
    required this.additionalChildren,
    required this.onGearUpdated,
  });

  @override
  State<EquipmentEditorDialog> createState() => _EquipmentEditorDialogState();
}

class _EquipmentEditorDialogState extends State<EquipmentEditorDialog> {
  late Equipment _gear;

  @override
  void initState() {
    _gear = widget.oldGear;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: _buildTitle(),
      shape: dialogShape,
      actions: widget.actions,
      content: Form(
        key: widget.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Column(
              children: [
                ..._formFields,
                const Gap(12),
                ...widget.additionalChildren,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_gear.name.isEmpty) {
      return const Text('New Item');
    }

    return Text(_gear.name);
  }

  List<Widget> get _formFields => [
        buildTextFormField(
          label: 'Name of the Item',
          defaultValue: _gear.name,
          validator: validateText,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _gear.name = value;
            });
            widget.onGearUpdated(_gear);
          },
          context: context,
        ),
        const Gap(12),
        buildTextFormField(
          keyboardType: TextInputType.number,
          allowsDecimal: true,
          defaultValue: _gear.weight.toString(),
          label: 'Weight of the Item',
          validator: validateNumber,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _gear.weight = parseInput<double>(value, double.parse) ?? 0;
            });
            widget.onGearUpdated(_gear);
          },
          context: context,
        ),
        const Gap(12),
        buildTextFormField(
          keyboardType: TextInputType.number,
          allowsDecimal: true,
          defaultValue: _gear.price.toString(),
          label: 'Price of the Item',
          validator: validateNumber,
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _gear.price = parseInput<double>(value, double.parse) ?? 0;
            });
            widget.onGearUpdated(_gear);
          },
          context: context,
        ),
      ];
}
