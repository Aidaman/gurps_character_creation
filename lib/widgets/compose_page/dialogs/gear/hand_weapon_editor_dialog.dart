import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/gear/gear.dart';
import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/gear_editor_dialog.dart';
import 'package:provider/provider.dart';

enum _HandWeaponEditorFields {
  DAMAGE_MODIFIER,
  MINIMUM_REACH,
  MAXIMUM_REACH,
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

  void updateHandWeaponFields(String? value, _HandWeaponEditorFields key) {
    if (value == null) {
      return;
    }

    switch (key) {
      case _HandWeaponEditorFields.ATTACK_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: AttackTypesString.fromString(value),
          modifier: _handWeapon.damage.modifier,
          damageType: _handWeapon.damage.damageType,
        );

        setState(() {
          _handWeapon =
              HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        });
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

        setState(() {
          _handWeapon =
              HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        });
        break;
      case _HandWeaponEditorFields.DAMAGE_TYPE:
        final WeaponDamage newWeaponDamage = WeaponDamage(
          attackType: _handWeapon.damage.attackType,
          modifier: _handWeapon.damage.modifier,
          damageType: DamageTypeString.fromString(value),
        );

        setState(() {
          _handWeapon =
              HandWeapon.copyWith(_handWeapon, damage: newWeaponDamage);
        });
        break;
      case _HandWeaponEditorFields.MINIMUM_REACH:
        int? newMinimalRange = parseInput<int>(value, int.parse);
        if (newMinimalRange != null) {
          _updateReach(_handWeapon.reach.maxReach, newMinimalRange);
        }

        break;
      case _HandWeaponEditorFields.MAXIMUM_REACH:
        int? newMaxRange = parseInput<int>(value, int.parse);
        setState(() {
          if (newMaxRange != null) {
            _updateReach(newMaxRange, _handWeapon.reach.minReach);
          }
        });

        break;
      default:
        break;
    }
  }

  void _updateReach(int newMaxReach, int? newMinReach) {
    HandWeaponReach newHandweaponReach = HandWeaponReach(
      minReach: newMinReach,
      maxReach: newMaxReach,
    );

    setState(() {
      _handWeapon = HandWeapon.copyWith(
        _handWeapon,
        reach: newHandweaponReach,
      );
    });
  }

  @override
  void initState() {
    _handWeapon = widget.oldHandWeapon ?? HandWeapon.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GearEditorDialog(
      formKey: _formkey,
      oldGear: _handWeapon,
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
              Navigator.pop(context, _handWeapon);
            }
          },
          label: const Text('add'),
        ),
      ],
      additionalChildren: [
        ..._ordinaryFields,
        _buildReachSection(),
        const Gap(16),
        _buildDamageSection(),
        const Gap(16),
        buildTextFormField(
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

            setState(() {
              _handWeapon = HandWeapon.copyWith(_handWeapon, notes: value);
            });
          },
          context: context,
        )
      ],
      onGearUpdated: (Gear updatedGear) {
        setState(() {
          _handWeapon = updatedGear as HandWeapon;
        });
      },
    );
  }

  List<Widget> get _ordinaryFields {
    final List<DropdownMenuItem<String>> assosiatedSkillsItems =
        Provider.of<AspectsProvider>(context)
            .skills
            .map(
              (Skill skl) => DropdownMenuItem(
                value: skl.name,
                child: Text(
                  skl.name,
                ),
              ),
            )
            .toList();

    return [
      buildTextFormField(
        label: 'Minimum Strengths ',
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

          setState(() {
            _handWeapon = HandWeapon.copyWith(
              _handWeapon,
              minimumSt: parseInput<int>(value, int.parse),
            );
          });
        },
        context: context,
      ),
      const Gap(8),
      Text(
        'In GURPS all martial weapons require some ST value for effective use',
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(24),
      buildFormDropdownMenu<String>(
        hint: 'Associated skill',
        initialValue: widget.oldHandWeapon?.associatedSkillName,
        items: assosiatedSkillsItems,
        onChanged: (String? value) => setState(() {
          _handWeapon = HandWeapon.copyWith(
            _handWeapon,
            associatedSkillName: value,
          );
          print(_handWeapon.associatedSkillName);
        }),
        context: context,
      ),
      const Gap(8),
      Text(
        'In GURPS all weapons require some Skill for effectuve usage, parry, etc.',
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(16),
    ];
  }

  Widget _buildReachSection() {
    return markAsGroup(
      title: 'Reach',
      description: 'In GURPS all weapons have effective range of usage',
      child: Row(
        children: [
          Expanded(
            child: buildTextFormField(
              label: 'Min Rearch',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldHandWeapon?.reach.minReach.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) => updateHandWeaponFields(
                value,
                _HandWeaponEditorFields.MINIMUM_REACH,
              ),
              context: context,
            ),
          ),
          const Gap(16),
          Expanded(
            child: buildTextFormField(
              label: 'Max Reach',
              defaultValue: widget.oldHandWeapon?.reach.maxReach.toString(),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              validator: validatePositiveNumber,
              onChanged: (String? value) => updateHandWeaponFields(
                value,
                _HandWeaponEditorFields.MAXIMUM_REACH,
              ),
              context: context,
            ),
          ),
        ],
      ),
      context: context,
    );
  }

  void onAttackTypeChanged(AttackTypes? value) {
    if (value == null) {
      return;
    }

    updateHandWeaponFields(
      value.stringValue,
      _HandWeaponEditorFields.ATTACK_TYPE,
    );
  }

  void onDamageTypeChanged(DamageType? value) {
    if (value == null) {
      return;
    }

    updateHandWeaponFields(
      value.stringValue,
      _HandWeaponEditorFields.DAMAGE_TYPE,
    );
  }

  Widget _buildDamageSection() {
    final List<DropdownMenuItem<AttackTypes>> attackTypesItems =
        AttackTypes.values
            .where((AttackTypes type) => type != AttackTypes.NONE)
            .map((AttackTypes type) => DropdownMenuItem<AttackTypes>(
                  value: type,
                  child: Text(
                    type.stringValue,
                  ),
                ))
            .toList();

    final List<DropdownMenuItem<DamageType>> damageTypesItems =
        DamageType.values
            .where((DamageType type) => type != DamageType.NONE)
            .map((DamageType type) => DropdownMenuItem<DamageType>(
                  value: type,
                  child: Text(
                    type.stringValue,
                  ),
                ))
            .toList();

    return markAsGroup(
      title: 'Damage',
      description:
          'In GURPS weapons can inflict either Thrust or Swing damage\nAlso you can clarify some bonus to damage with this weapon',
      child: Column(
        children: [
          buildFormDropdownMenu(
            hint: 'Attack type',
            initialValue: widget.oldHandWeapon?.damage.attackType,
            items: attackTypesItems,
            onChanged: onAttackTypeChanged,
            context: context,
          ),
          const Gap(16),
          buildTextFormField(
            label: 'weapon damage modifier',
            keyboardType: TextInputType.number,
            allowsDecimal: false,
            defaultValue: widget.oldHandWeapon?.damage.modifier.toString(),
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
            context: context,
          ),
          const Gap(16),
          buildFormDropdownMenu(
            hint: 'Damage type',
            initialValue: widget.oldHandWeapon?.damage.damageType,
            items: damageTypesItems,
            onChanged: onDamageTypeChanged,
            context: context,
          ),
        ],
      ),
      context: context,
    );
  }
}
