import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/dialog_size.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
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
    return AlertDialog.adaptive(
      title: _buildTitle(),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: ConstrainedBox(
        constraints: defineDialogConstraints(context),
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
          const Gap(16),
          _buildTextFormField(
            maxLines: null,
            defaultValue: widget.oldHandWeapon?.notes,
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
    const String MIN_ST_EXPLANATION =
        'All Handweapons in GURPS have a minimum Strength required to wield them\nIf your character ST is lower than this parametre — they will receive a penalty to any check for the weapon equal to: Character ST - Minimum ST';
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
      const Gap(12),
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
      const Gap(12),
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
      const Gap(24),
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
      const Gap(8),
      Text(
        MIN_ST_EXPLANATION,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(24),
      _buildFormDropdownMenu<String>(
        hint: 'Associated skill',
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
      const Gap(8),
      Text(
        'Any weapon has a skill attached that determines how successfull you parry and hit with a given weapon',
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(16),
    ];
  }

  Widget _buildReachSection() {
    return _markAsGroup(
      title: 'Reach',
      description:
          'Any weapon in GURPS has an effective distance that is measured in Hexes. Hex is a 0.9 meters (1yard) hexagon area',
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
      description:
          'Any weapon has an attack type (Thrust or Swing). The Swing damage is higher since the weapon functions as a lever in that case\n\nAny weapon has some modifier on top of the basic throw. For example Thr+2 means you pick a Thrusting throw from the table and add 2\n\nAnd damage type is self explainatory',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildFormDropdownMenu(
                  hint: 'Attack type',
                  initialValue: widget.oldHandWeapon?.damage.attackType,
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
            hint: 'Damage type',
            initialValue: widget.oldHandWeapon?.damage.damageType,
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
    String? description,
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
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            child,
            const Gap(16),
            if (description != null)
              Text(
                description,
                style: Theme.of(context).textTheme.labelSmall,
              )
          ],
        ),
      ),
    );
  }

  Widget _buildFormDropdownMenu<T>({
    required List<DropdownMenuItem<T>> items,
    required void Function(T? value) onChanged,
    required String hint,
    T? initialValue,
  }) {
    return Column(
      children: [
        DropdownButtonFormField<T>(
          style: Theme.of(context).textTheme.bodyMedium,
          borderRadius: BorderRadius.circular(8),
          hint: Text(hint),
          items: items,
          onChanged: onChanged,
          value: initialValue,
        ),
      ],
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
}
