import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:provider/provider.dart';

enum _HandWeaponEditorFields {
  DAMAGE_MODIFIER,
  MINIMUM_REACH_DISTANCE,
  MAXIMUM_REACH_DISTANCE,
  ATTACK_TYPE,
  DAMAGE_TYPE,
}

class HandWeaponEditorDialog extends StatefulWidget {
  final HandWeapon? oldHandWeapon;

  const HandWeaponEditorDialog({super.key, this.oldHandWeapon});

  @override
  State<HandWeaponEditorDialog> createState() => _HandWeaponEditorDialogState();
}

class _HandWeaponEditorDialogState extends State<HandWeaponEditorDialog> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  HandWeapon _handWeapon = HandWeapon.empty();

  void updateHandWeaponFields(String value, _HandWeaponEditorFields key) {
    switch (key) {
      case _HandWeaponEditorFields.ATTACK_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: AttackTypesString.fromString(value),
          modifier: _handWeapon.damage.modifier,
          damageType: _handWeapon.damage.damageType,
        );

        _handWeapon = HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.DAMAGE_MODIFIER:
        int? newModifier = parseInput<int>(value, int.parse);
        if (newModifier == null) {
          return;
        }

        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: _handWeapon.damage.attackType,
          modifier: newModifier,
          damageType: _handWeapon.damage.damageType,
        );

        _handWeapon = HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.DAMAGE_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: _handWeapon.damage.attackType,
          modifier: _handWeapon.damage.modifier,
          damageType: DamageTypeString.fromString(value),
        );

        _handWeapon = HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        break;
      case _HandWeaponEditorFields.MINIMUM_REACH_DISTANCE:
        int? newMinimalRange = parseInput<int>(value, int.parse);
        if (newMinimalRange != null) {
          _updateMinimalRange(newMinimalRange);
        }

        break;
      case _HandWeaponEditorFields.MAXIMUM_REACH_DISTANCE:
        int? newMaxRange = parseInput<int>(value, int.parse);
        if (newMaxRange != null) {
          _updateMaximalRange(newMaxRange);
        }

        break;
      default:
        break;
    }
  }

  void _updateMaximalRange(int newMaxRange) {
    bool maximumRangeIsNull = _handWeapon.reach.maximumRange == null;
    bool minIsMoreThanMax = _handWeapon.reach.minimalRange > newMaxRange;

    if (!maximumRangeIsNull && minIsMoreThanMax) {
      _handWeapon = HandWeapon.copyWith(
        _handWeapon,
        reach: HandWeaponReach(
          minimalRange: newMaxRange,
          maximumRange: _handWeapon.reach.minimalRange,
        ),
      );
    }

    HandWeaponReach newHandweaponReach = HandWeaponReach(
      minimalRange: _handWeapon.reach.minimalRange,
      maximumRange: newMaxRange,
    );

    _handWeapon = HandWeapon.copyWith(
      _handWeapon,
      reach: newHandweaponReach,
    );
  }

  void _updateMinimalRange(int newMinimalRange) {
    HandWeaponReach newHandweaponReach = HandWeaponReach(
      minimalRange: newMinimalRange,
    );

    bool maximumRangeIsNull = _handWeapon.reach.maximumRange == null;
    bool maxIsLessThanMin = _handWeapon.reach.maximumRange! < newMinimalRange;

    if (!maximumRangeIsNull && maxIsLessThanMin) {
      newHandweaponReach = HandWeaponReach(
        minimalRange: _handWeapon.reach.maximumRange!,
        maximumRange: newMinimalRange,
      );
    }

    _handWeapon = HandWeapon.copyWith(
      _handWeapon,
      reach: newHandweaponReach,
    );
  }

  @override
  void initState() {
    if (widget.oldHandWeapon != null) {
      _handWeapon = widget.oldHandWeapon!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    RoundedRectangleBorder dialogShape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    );

    return AlertDialog.adaptive(
      title: _buildTitle(),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: ConstrainedBox(
        constraints: _defineConstraints(context),
        child: SingleChildScrollView(
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_handWeapon.name == '') {
      return const Text('New Weapon');
    }

    return Text(_handWeapon.name);
  }

  List<Widget> _buildActions(BuildContext context) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.pop(context, null);
        },
        label: const Text('cancel'),
      ),
      FilledButton.icon(
        onPressed: () {
          Navigator.pop(context, _handWeapon);
        },
        label: const Text('add'),
      ),
    ];
  }

  Form _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: <Widget>[
          ..._buildBaseInfoSection(),
          _buildReachSection(),
          const Gap(16),
          _buildDamageSection(),
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

              _handWeapon = HandWeapon.copyWith(_handWeapon, notes: value);
            },
          )
        ],
      ),
    );
  }

  List<Widget> _buildBaseInfoSection() {
    return [
      _buildTextFormField(
        label: 'Name of the weapon',
        defaultValue: widget.oldHandWeapon?.name,
        validator: validateText,
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _handWeapon = HandWeapon.copyWith(_handWeapon, name: value);
          });
        },
      ),
      const Gap(16),
      _buildTextFormField(
        keyboardType: TextInputType.number,
        allowsDecimal: true,
        defaultValue: widget.oldHandWeapon?.weight.toString(),
        label: 'Weight of the weapon',
        validator: validateNumber,
        onChanged: (value) {
          if (value == null) {
            return;
          }

          _handWeapon = HandWeapon.copyWith(
            _handWeapon,
            weight: parseInput<double>(value, double.parse),
          );
        },
      ),
      const Gap(16),
      _buildTextFormField(
        keyboardType: TextInputType.number,
        allowsDecimal: true,
        defaultValue: widget.oldHandWeapon?.price.toString(),
        label: 'Price of the weapon',
        validator: validateNumber,
        onChanged: (value) {
          if (value == null) {
            return;
          }

          _handWeapon = HandWeapon.copyWith(
            _handWeapon,
            price: parseInput<double>(value, double.parse),
          );
        },
      ),
      const Gap(16),
      _buildTextFormField(
        label: 'Minimum Strengths required to wield this weapon',
        defaultValue: widget.oldHandWeapon?.minimumSt.toString(),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: false,
        ),
        allowsDecimal: false,
        validator: validatePositiveNumber,
        onChanged: (String? value) {
          if (value == null) {
            return;
          }

          _handWeapon = HandWeapon.copyWith(
            _handWeapon,
            minimumSt: parseInput<int>(value, int.parse),
          );
        },
      ),
      const Gap(16),
      _buildFormDropdownMenu<String>(
        initialValue: widget.oldHandWeapon?.associatedSkillName,
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
        onChanged: (String? value) {
          if (value == null) {
            return;
          }

          _handWeapon = HandWeapon.copyWith(
            _handWeapon,
            associatedSkillName: value,
          );
        },
      ),
      const Gap(16),
    ];
  }

  Widget _buildReachSection() {
    return _markAsGroup(
      title: 'Reach',
      child: Row(
        children: [
          Expanded(
            child: _buildTextFormField(
              label: 'Minimum Reach Distance in hexes',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldHandWeapon?.reach.minimalRange.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                updateHandWeaponFields(
                  value,
                  _HandWeaponEditorFields.MINIMUM_REACH_DISTANCE,
                );
              },
            ),
          ),
          const Gap(16),
          Expanded(
            child: _buildTextFormField(
              label: 'maximum Reach Distance in hexes',
              defaultValue: widget.oldHandWeapon?.reach.maximumRange.toString(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                updateHandWeaponFields(
                  value,
                  _HandWeaponEditorFields.MAXIMUM_REACH_DISTANCE,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDamageSection() {
    return _markAsGroup(
      title: 'Damage',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFormDropdownMenu(
                  items: AttackTypes.values
                      .where((AttackTypes type) => type != AttackTypes.NONE)
                      .map((AttackTypes type) => DropdownMenuItem<AttackTypes>(
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
                      widget.oldHandWeapon?.damage.modifier.toString(),
                  validator: validateWoleNumber,
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
            ],
          ),
          const Gap(16),
          _buildFormDropdownMenu(
            items: DamageType.values
                .where((DamageType type) => type != DamageType.NONE)
                .map((DamageType type) => DropdownMenuItem<DamageType>(
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
        ],
      ),
    );
  }

  Widget _markAsGroup({
    required Widget child,
    required String title,
  }) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: 16.0,
          left: 8,
          right: 8,
        ),
        child: Column(
          children: [
            Text(title),
            child,
          ],
        ),
      ),
    );
  }

  DropdownButtonFormField _buildFormDropdownMenu<T>({
    required List<DropdownMenuItem<T>> items,
    required void Function(T? value) onChanged,
    T? initialValue,
  }) {
    return DropdownButtonFormField<T>(
      items: items,
      onChanged: onChanged,
      value: initialValue,
    );
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
      inputFormatters: addTextInputFormatters(keyboardType, allowsDecimal),
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

  BoxConstraints _defineConstraints(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxHeight = MediaQuery.of(context).size.height / 2;

    if (screenWidth > MIN_DESKTOP_WIDTH) {
      return BoxConstraints(
        maxHeight: maxHeight,
        maxWidth: min(screenWidth / 2, MAX_DESKTOP_CONTENT_WIDTH / 2),
        minWidth: min(screenWidth / 2, MAX_DESKTOP_CONTENT_WIDTH / 2),
      );
    }

    if (screenWidth < MIN_DESKTOP_WIDTH && screenWidth > MAX_MOBILE_WIDTH) {
      return BoxConstraints(
        minHeight: maxHeight,
        minWidth: screenWidth / 2,
        maxWidth: screenWidth / 2,
      );
    }

    return BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height - MOBILE_VERTICAL_PADDING,
      maxWidth: screenWidth - MOBILE_HORIZONTAL_PADDING,
      minWidth: screenWidth - MOBILE_HORIZONTAL_PADDING,
    );
  }
}
