import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/dices.dart';
import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

enum _HandWeaponEditorFields {
  NAME,
  PRICE,
  WEIGHT,
  DAMAGE_MODIFIER,
  MINIMUM_REACH_DISTANCE,
  MAXIMUM_REACH_DISTANCE,
  ATTACK_TYPE,
  DAMAGE_TYPE,
  ASSOCIATED_SKILL,
  MIN_ST,
  NOTES,
}

class HandWeaponEditorDialog extends StatefulWidget {
  final HandWeapon? hw;

  const HandWeaponEditorDialog({super.key, this.hw});

  @override
  State<HandWeaponEditorDialog> createState() => _HandWeaponEditorDialogState();
}

class _HandWeaponEditorDialogState extends State<HandWeaponEditorDialog> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  HandWeapon _hw = HandWeapon.empty();

  void updateHandWeaponFields(String value, _HandWeaponEditorFields key) {
    switch (key) {
      case _HandWeaponEditorFields.NAME:
        _hw = HandWeapon.copyWith(_hw, name: value);
        break;
      case _HandWeaponEditorFields.PRICE:
        if (double.tryParse(value) != null) {
          _hw = HandWeapon.copyWith(
            _hw,
            price: double.parse(value),
          );
        }
        break;
      case _HandWeaponEditorFields.WEIGHT:
        if (double.tryParse(value) != null) {
          _hw = HandWeapon.copyWith(
            _hw,
            weight: double.parse(value),
          );
        }
        break;
      case _HandWeaponEditorFields.MIN_ST:
        if (int.tryParse(value) != null) {
          _hw = HandWeapon.copyWith(
            _hw,
            minimumSt: int.parse(value),
          );
        }
        break;
      case _HandWeaponEditorFields.ASSOCIATED_SKILL:
        _hw = HandWeapon.copyWith(_hw, associatedSkillName: value);
        break;
      case _HandWeaponEditorFields.ATTACK_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: AttackTypesString.fromString(value),
          modifier: _hw.damage.modifier,
          damageType: _hw.damage.damageType,
        );

        _hw = HandWeapon.copyWith(_hw, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.DAMAGE_MODIFIER:
        if (int.tryParse(value) == null) {
          return;
        }

        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: _hw.damage.attackType,
          modifier: int.parse(value),
          damageType: _hw.damage.damageType,
        );

        _hw = HandWeapon.copyWith(_hw, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.DAMAGE_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: _hw.damage.attackType,
          modifier: _hw.damage.modifier,
          damageType: DamageTypeString.fromString(value),
        );

        _hw = HandWeapon.copyWith(_hw, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.MINIMUM_REACH_DISTANCE:
        if (int.tryParse(value) == null) {
          return;
        }

        final HandWeaponReach newHandweaponReach =
            HandWeaponReach(minimalRange: int.parse(value));

        _hw = HandWeapon.copyWith(_hw, reach: newHandweaponReach);
        break;
      case _HandWeaponEditorFields.MAXIMUM_REACH_DISTANCE:
        if (int.tryParse(value) == null) {
          return;
        }

        final HandWeaponReach newHandweaponReach = HandWeaponReach(
          minimalRange: _hw.reach.minimalRange,
          maximumRange: int.parse(value),
        );

        if (newHandweaponReach.maximumRange! <
            newHandweaponReach.minimalRange) {
          _hw = HandWeapon.copyWith(
            _hw,
            reach: HandWeaponReach(
              minimalRange: newHandweaponReach.maximumRange!,
              maximumRange: newHandweaponReach.minimalRange,
            ),
          );
        }

        _hw = HandWeapon.copyWith(_hw, reach: newHandweaponReach);
        break;
      case _HandWeaponEditorFields.NOTES:
        _hw = HandWeapon.copyWith(_hw, notes: value);
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    if (widget.hw != null) {
      _hw = widget.hw!;
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        BoxConstraints size = _defineConstraints(constraints);

        return AlertDialog.adaptive(
          title: _hw.name == '' ? const Text('New Weapon') : Text(_hw.name),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          actions: [
            TextButton.icon(
              onPressed: () {
                Navigator.pop(context, null);
              },
              label: const Text('cancel'),
            ),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context, _hw);
              },
              label: const Text('add'),
            ),
          ],
          scrollable: true,
          content: ConstrainedBox(
            constraints: size,
            child: SingleChildScrollView(
              child: Form(
                key: _formkey,
                child: SizedBox(
                  child: Column(
                    children: [
                      _buildTextFormField(
                        label: 'Name of the weapon',
                        defaultValue: widget.hw?.name,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter some text';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          updateHandWeaponFields(
                            value,
                            _HandWeaponEditorFields.NAME,
                          );
                        },
                      ),
                      const Gap(16),
                      _buildTextFormField(
                        keyboardType: TextInputType.number,
                        allowsDecimal: true,
                        defaultValue: widget.hw?.weight.toString(),
                        label: 'Weight of the weapon',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter some number';
                          }

                          if (double.tryParse(value) == null) {
                            return 'whatever you want to do, please, just enter a number';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          updateHandWeaponFields(
                            value,
                            _HandWeaponEditorFields.WEIGHT,
                          );
                        },
                      ),
                      const Gap(16),
                      _buildTextFormField(
                        keyboardType: TextInputType.number,
                        allowsDecimal: true,
                        defaultValue: widget.hw?.price.toString(),
                        label: 'Price of the weapon',
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter some number';
                          }

                          if (double.tryParse(value) == null) {
                            return 'whatever you want to do, please, just enter a number';
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          updateHandWeaponFields(
                            value,
                            _HandWeaponEditorFields.PRICE,
                          );
                        },
                      ),
                      const Gap(16),
                      _buildTextFormField(
                        label:
                            'Minimum Strengths required to wield this weapon',
                        defaultValue: widget.hw?.minimumSt.toString(),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                        ),
                        allowsDecimal: false,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter some positive number';
                          }

                          if (int.tryParse(value) == null) {
                            return 'whatever you want to do, please, just enter a positive number';
                          }

                          return null;
                        },
                        onChanged: (String? value) {
                          if (value == null) {
                            return;
                          }

                          updateHandWeaponFields(
                            value,
                            _HandWeaponEditorFields.MIN_ST,
                          );
                        },
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextFormField(
                              label: 'Minimum Reach Distance in hexes',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: false,
                              ),
                              allowsDecimal: false,
                              defaultValue:
                                  widget.hw?.reach.minimalRange.toString(),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'please enter some positive number';
                                }

                                if (int.tryParse(value) == null) {
                                  return 'whatever you want to do, please, just enter a positive number';
                                }

                                return null;
                              },
                              onChanged: (String? value) {
                                if (value == null) {
                                  return;
                                }

                                updateHandWeaponFields(
                                  value,
                                  _HandWeaponEditorFields
                                      .MINIMUM_REACH_DISTANCE,
                                );
                              },
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: _buildTextFormField(
                              label: 'maximum Reach Distance in hexes',
                              defaultValue:
                                  widget.hw?.reach.maximumRange.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: false,
                              ),
                              allowsDecimal: false,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'please enter some positive number';
                                }

                                if (int.tryParse(value) == null) {
                                  return 'whatever you want to do, please, just enter a positive number';
                                }

                                return null;
                              },
                              onChanged: (String? value) {
                                if (value == null) {
                                  return;
                                }

                                updateHandWeaponFields(
                                  value,
                                  _HandWeaponEditorFields
                                      .MAXIMUM_REACH_DISTANCE,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildFormDropdownMenu(
                              items: AttackTypes.values
                                  .where((AttackTypes type) =>
                                      type != AttackTypes.NONE)
                                  .map((AttackTypes type) =>
                                      DropdownMenuItem<AttackTypes>(
                                        value: type,
                                        child: Text(
                                          type.stringValue,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (AttackTypes? value) {
                                if (value == null) {
                                  return;
                                }

                                updateHandWeaponFields(
                                  value.stringValue,
                                  _HandWeaponEditorFields.ATTACK_TYPE,
                                );
                              },
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: _buildTextFormField(
                              label: 'weapon damage modifier',
                              keyboardType: TextInputType.number,
                              allowsDecimal: false,
                              defaultValue:
                                  widget.hw?.damage.modifier.toString(),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some whole number';
                                }

                                if (int.tryParse(value) == null) {
                                  return 'Whatever you do, just enter a whole number';
                                }

                                return null;
                              },
                              onChanged: (String? value) {
                                if (value == null) {
                                  return;
                                }

                                updateHandWeaponFields(
                                  value,
                                  _HandWeaponEditorFields.DAMAGE_MODIFIER,
                                );
                              },
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: _buildFormDropdownMenu(
                              items: DamageType.values
                                  .where((DamageType type) =>
                                      type != DamageType.NONE)
                                  .map((DamageType type) =>
                                      DropdownMenuItem<DamageType>(
                                        value: type,
                                        child: Text(
                                          type.stringValue,
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (DamageType? value) {
                                if (value == null) {
                                  return;
                                }

                                updateHandWeaponFields(
                                  value.stringValue,
                                  _HandWeaponEditorFields.DAMAGE_TYPE,
                                );
                              },
                            ),
                          ),
                          const Gap(16),
                        ],
                      ),
                      _buildFormDropdownMenu<String>(
                        items: Provider.of<AspectsProvider>(context)
                            .skills
                            .map(
                              (Skill skl) => DropdownMenuItem(
                                value: skl.name,
                                child: Text(
                                  skl.name,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {},
                      ),
                      _buildTextFormField(
                        maxLines: null,
                        label: 'Notes for this Weapon',
                        keyboardType: TextInputType.multiline,
                        validator: (String? value) {
                          return null;
                        },
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          updateHandWeaponFields(
                            value,
                            _HandWeaponEditorFields.NOTES,
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  DropdownButtonFormField _buildFormDropdownMenu<T>({
    required List<DropdownMenuItem<T>> items,
    required void Function(T? value) onChanged,
  }) {
    return DropdownButtonFormField<T>(
      items: items,
      onChanged: onChanged,
    );
  }

  List<TextInputFormatter> _addTextInputFormatters(
    TextInputType? keyboardType,
    bool? isDecimal,
  ) {
    if (keyboardType == null) {
      return [];
    }

    List<TextInputFormatter> formatters = [];

    if (isDecimal != null) {
      formatters.add(
        FilteringTextInputFormatter.allow(
          isDecimal
              ? RegExp(r'^\d+\.?\d{0,2}') // Allows decimals with up to 2 places
              : RegExp(r'^\d+'), // Restricts to integers only
        ),
      );
    }

    return formatters;
  }

  Widget _buildTextFormField({
    required String label,
    required String? Function(String? str) validator,
    required void Function(String? value) onChanged,
    String? defaultValue,
    TextInputType? keyboardType,
    int? maxLines = 1,
    bool? allowsDecimal,
  }) {
    return TextFormField(
      maxLines: maxLines,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType ?? TextInputType.text,
      inputFormatters: _addTextInputFormatters(keyboardType, allowsDecimal),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 12,
        ),
      ),
      initialValue: defaultValue,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildDropdownMenu<T>({
    required String label,
    required TextEditingController controller,
    required List<DropdownMenuEntry<T>> entries,
    required void Function(T? value) onSelected,
    String? description,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownMenu(
          enableFilter: true,
          dropdownMenuEntries: entries,
          onSelected: onSelected,
        ),
      ),
    );
  }

  BoxConstraints _defineConstraints(BoxConstraints constraints) {
    final double maxHeight = constraints.maxHeight / 2;
    final double minHeight = constraints.maxHeight / 2;

    if (constraints.maxWidth > MIN_DESKTOP_WIDTH) {
      return BoxConstraints(
        maxHeight: maxHeight,
        minHeight: minHeight,
        minWidth: constraints.maxWidth / 3,
        maxWidth: constraints.maxWidth / 3,
      );
    }

    if (constraints.maxWidth < MIN_DESKTOP_WIDTH &&
        constraints.maxWidth > MAX_MOBILE_WIDTH) {
      return BoxConstraints(
        maxHeight: maxHeight,
        minHeight: minHeight,
        maxWidth: (constraints.maxWidth / 1.5),
        minWidth: (constraints.maxWidth / 1.5),
      );
    }

    return BoxConstraints(
      maxHeight: maxHeight,
      minHeight: minHeight,
      maxWidth: constraints.maxWidth - MOBILE_HORIZONTAL_PADDING,
      minWidth: constraints.maxWidth - MOBILE_HORIZONTAL_PADDING,
    );
  }
}
