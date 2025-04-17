import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_modifier.dart';
import 'package:gurps_character_creation/widgets/traits/trait_modifier_view.dart';

class SelectTraitModifiersDialog extends StatefulWidget {
  final Trait trait;

  const SelectTraitModifiersDialog({super.key, required this.trait});

  @override
  State<SelectTraitModifiersDialog> createState() =>
      _SelectTraitModifiersDialogState();
}

class _SelectTraitModifiersDialogState
    extends State<SelectTraitModifiersDialog> {
  final List<TraitModifier> _selectedTraitModifiers = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: _buildTitle(),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: SingleChildScrollView(
        child: _buildForm(),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(widget.trait.name);
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context, null);
        },
        label: const Text('add with none'),
      ),
      FilledButton.icon(
        onPressed: () {
          Navigator.pop(context, _selectedTraitModifiers);
        },
        label: const Text('add'),
      ),
    ];
  }

  Widget _buildForm() {
    widget.trait.modifiers.sort(
      (TraitModifier a, TraitModifier b) => a.cost.toInt() - b.cost.toInt(),
    );

    return Column(
      children: List.from(
        widget.trait.modifiers.map(
          (TraitModifier trtModifier) => TraitModifierView(
            traitModifier: trtModifier,
            isSelected: _selectedTraitModifiers
                .where(
                  (TraitModifier modifier) => modifier.name == trtModifier.name,
                )
                .isNotEmpty,
            onChanged: (newValue) => _selectModifier(newValue, trtModifier),
          ),
        ),
      ),
    );
  }

  void _selectModifier(bool? newValue, TraitModifier trtModifier) {
    if (newValue == null) {
      return;
    }

    if (newValue && trtModifier.cost == 0) {
      setState(() {
        _selectedTraitModifiers.add(trtModifier);
      });
      return;
    }

    if (newValue && trtModifier.cost != 0) {
      setState(() {
        _selectedTraitModifiers.removeWhere(
          (TraitModifier modifier) => modifier.cost != 0,
        );

        _selectedTraitModifiers.add(trtModifier);
      });
      return;
    }

    setState(() {
      _selectedTraitModifiers.removeWhere(
        (TraitModifier modifier) => modifier.name == trtModifier.name,
      );
    });
  }
}
