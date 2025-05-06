import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/equipment/models/armor.dart';
import 'package:gurps_character_creation/features/equipment/models/equipment.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/equipment/equipment_editor_dialog.dart';

class ArmorEditorDialog extends StatefulWidget {
  final Armor? oldArmor;

  const ArmorEditorDialog({super.key, this.oldArmor});

  @override
  State<ArmorEditorDialog> createState() => _ArmorEditorDialogState();
}

class _ArmorEditorDialogState extends State<ArmorEditorDialog> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  late Armor _armor;

  @override
  void initState() {
    _armor = widget.oldArmor ?? Armor.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EquipmentEditorDialog(
      formKey: _formkey,
      oldGear: _armor,
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
              Navigator.pop(context, _armor);
            }
          },
          label: const Text('add'),
        ),
      ],
      additionalChildren: [
        buildFormDropdownMenu<BodyPart>(
          hint: 'Armor Location',
          initialValue: _armor.armorLocation != BodyPart.NONE
              ? _armor.armorLocation
              : BodyPart.TORSO,
          items: BodyPart.values
              .where(
                (BodyPart bodyPart) => bodyPart != BodyPart.NONE,
              )
              .map(
                (BodyPart bodyPart) => DropdownMenuItem(
                  value: bodyPart,
                  child: Text(bodyPart.stringValue),
                ),
              )
              .toList(),
          onChanged: (BodyPart? value) {
            if (value == null) {
              return;
            }

            setState(() {
              _armor = Armor.copyWith(
                _armor,
                armorLocation: value,
              );
            });
          },
          context: context,
        ),
        markAsGroup(
          context: context,
          title: 'Damage Resistance',
          child: Column(
            children: [
              buildTextFormField(
                context: context,
                label: 'Damage Resistance',
                validator: validateNumber,
                defaultValue:
                    _armor.damageResistance.damageResistance.toString(),
                onChanged: (String? value) {
                  if (value == null) {
                    return;
                  }

                  int? parsedValue = parseInput<int>(value, int.parse);

                  if (parsedValue == null) {
                    return;
                  }

                  setState(
                    () {
                      _armor = Armor.copyWith(
                        _armor,
                        damageResistance: DamageResistance(
                          resistance: parsedValue,
                          denominatorResistance:
                              _armor.damageResistance.denominatorResistance,
                          isFlexible: _armor.damageResistance.isFlexible,
                          isFrontOnly: _armor.damageResistance.isFrontOnly,
                        ),
                      );
                    },
                  );
                },
              ),
              const Gap(8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Is Flexible'),
                        Switch.adaptive(
                          value: _armor.damageResistance.isFlexible,
                          onChanged: (bool value) => setState(
                            () {
                              _armor = Armor.copyWith(
                                _armor,
                                damageResistance: DamageResistance(
                                  resistance:
                                      _armor.damageResistance.damageResistance,
                                  denominatorResistance: _armor
                                      .damageResistance.denominatorResistance,
                                  isFlexible: value,
                                  isFrontOnly:
                                      _armor.damageResistance.isFrontOnly,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const Text('Is Front Only'),
                        Switch.adaptive(
                          value: _armor.damageResistance.isFrontOnly,
                          onChanged: (bool value) => setState(
                            () {
                              _armor = Armor.copyWith(
                                _armor,
                                damageResistance: DamageResistance(
                                  resistance:
                                      _armor.damageResistance.damageResistance,
                                  denominatorResistance: _armor
                                      .damageResistance.denominatorResistance,
                                  isFlexible:
                                      _armor.damageResistance.isFlexible,
                                  isFrontOnly: value,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const Gap(16),
        buildTextFormField(
          maxLines: null,
          defaultValue: widget.oldArmor?.notes,
          label: 'Notes for this Item',
          keyboardType: TextInputType.multiline,
          validator: (String? value) {
            return null;
          },
          onChanged: (value) {
            if (value == null) {
              return;
            }

            setState(() {
              _armor = Armor.copyWith(_armor, notes: value);
            });
          },
          context: context,
        )
      ],
      onGearUpdated: (Equipment updatedGear) {
        setState(() {
          _armor = updatedGear as Armor;
        });
      },
    );
  }
}
