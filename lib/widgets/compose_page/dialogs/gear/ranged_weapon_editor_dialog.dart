import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/gear/gear.dart';
import 'package:gurps_character_creation/models/gear/legality_class.dart';
import 'package:gurps_character_creation/models/gear/weapons/damage_type.dart';
import 'package:gurps_character_creation/models/gear/weapons/ranged_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/gear_editor_dialog.dart';
import 'package:provider/provider.dart';

class RangedWeaponEditorDialog extends StatefulWidget {
  final RangedWeapon? oldRangedWeapon;

  const RangedWeaponEditorDialog({super.key, this.oldRangedWeapon});

  @override
  State<RangedWeaponEditorDialog> createState() =>
      _RangedWeaponEditorDialogState();
}

class _RangedWeaponEditorDialogState extends State<RangedWeaponEditorDialog> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  RangedWeapon _rangedWeapon = RangedWeapon.empty();

  @override
  void initState() {
    _rangedWeapon = widget.oldRangedWeapon ?? RangedWeapon.empty();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GearEditorDialog(
      formKey: _formkey,
      oldGear: _rangedWeapon,
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
              Navigator.pop(context, _rangedWeapon);
            }
          },
          label: const Text('add'),
        ),
      ],
      additionalChildren: [
        ..._ordinaryFields,
        const Gap(16),
        _buildDamageSection(),
        const Gap(16),
        _buildStSection(),
        const Gap(16),
        _buildRangeSection(),
        const Gap(16),
        _buildShotsSection(),
      ],
      onGearUpdated: (Gear updatedGear) {
        setState(() {
          _rangedWeapon = updatedGear as RangedWeapon;
        });
      },
    );
  }

  List<Widget> get _ordinaryFields => [
        buildTextFormField(
          label: 'Minimum Strengths required to wield this weapon',
          defaultValue: widget.oldRangedWeapon?.minimumSt.toString(),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: false,
          ),
          allowsDecimal: false,
          validator: validatePositiveNumber,
          onChanged: (String? value) {
            if (value == null) {
              return;
            }

            _rangedWeapon = RangedWeapon.copyWith(
              _rangedWeapon,
              minimumSt: parseInput<int>(value, int.parse),
            );
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'In GURPS all martial weapons require some ST value for effective use',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(24),
        buildFormDropdownMenu<String>(
          hint: 'Associated skill',
          initialValue: widget.oldRangedWeapon?.associatedSkillName,
          items: Provider.of<AspectsProvider>(context)
              .skills
              .map(
                (Skill skl) => DropdownMenuItem(
                  value: skl.name,
                  child: Text(skl.name),
                ),
              )
              .toList(),
          onChanged: (String? value) {
            _rangedWeapon = RangedWeapon.copyWith(
              _rangedWeapon,
              associatedSkillName: value,
            );
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'In GURPS all weapons require some Skill for effectuve usage, parry, etc.',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(16),
        buildFormDropdownMenu<LegalityClass>(
          hint: 'Legality Class',
          initialValue: _rangedWeapon.lc != LegalityClass.NONE
              ? _rangedWeapon.lc
              : LegalityClass.OPEN,
          items: LegalityClass.values
              .where(
                (lc) => lc != LegalityClass.NONE,
              )
              .map(
                (LegalityClass lc) => DropdownMenuItem(
                  value: lc,
                  child: Text(lc.stringValue),
                ),
              )
              .toList(),
          onChanged: (LegalityClass? value) {
            setState(() {
              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                lc: value,
              );
            });
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'In GURPS ranged weapons may be illegal, that influence NPCs reaction on PC',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(24),
        buildTextFormField(
          label: 'Accuracy',
          defaultValue: widget.oldRangedWeapon?.accuracy.toString(),
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
              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                accuracy: parseInput<int>(value, int.parse),
              );
            });
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'In GURPS aiming in your turn grants +Accuracy advantage to next skill check',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(24),
        buildTextFormField(
          label: 'Rate Of Fire',
          defaultValue: widget.oldRangedWeapon?.rateOfFire.toString(),
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
              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                rateOfFire: parseInput<int>(value, int.parse),
              );
            });
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'Amount of shots per second',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(24),
        buildTextFormField(
          label: 'Bulk',
          defaultValue: widget.oldRangedWeapon?.bulk.toString(),
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
              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                bulk: parseInput<int>(value, int.parse),
              );
            });
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'A measure of the weapon\'s size and handines',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(24),
        buildTextFormField(
          label: 'Recoil',
          defaultValue: widget.oldRangedWeapon?.recoil.toString(),
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
              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                recoil: parseInput<int>(value, int.parse),
              );
            });
          },
          context: context,
        ),
        const Gap(4),
        Text(
          'A measure of how easy the weapon is to control when firing rapidly\n1 means no recoil',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ];

  Widget _buildRangeSection() {
    return markAsGroup(
      child: Column(
        children: [
          buildTextFormField(
            label: 'Min Range',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            allowsDecimal: false,
            defaultValue: widget.oldRangedWeapon?.range.minRange.toString(),
            validator: validatePositiveNumber,
            onChanged: (String? value) {
              if (value == null) {
                return;
              }

              setState(() {
                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  range: Range(
                    minRange: parseInput<int>(value, int.parse) ?? 0,
                    maxRange: _rangedWeapon.range.maxRange,
                  ),
                );
              });
            },
            context: context,
          ),
          const Gap(16),
          buildTextFormField(
            label: 'Max Range',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            allowsDecimal: false,
            defaultValue: widget.oldRangedWeapon?.range.maxRange.toString(),
            validator: validatePositiveNumber,
            onChanged: (String? value) {
              if (value == null) {
                return;
              }

              setState(() {
                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  range: Range(
                    minRange: _rangedWeapon.range.minRange,
                    maxRange: parseInput<int>(value, int.parse) ?? 0,
                  ),
                );
              });
            },
            context: context,
          ),
        ],
      ),
      title: 'Range',
      context: context,
    );
  }

  Widget _buildShotsSection() {
    return markAsGroup(
      child: Row(
        children: [
          Expanded(
            child: buildTextFormField(
              label: 'Shots Available',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldRangedWeapon?.range.minRange.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  shots: RangeWeaponShots(
                    shotsAvailable: parseInput(value, int.parse) ?? 0,
                  ),
                );
              },
              context: context,
            ),
          ),
          const Gap(16),
          Expanded(
            child: buildTextFormField(
              label: 'Shots Before Complete Reload',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldRangedWeapon?.range.maxRange.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  shots: RangeWeaponShots(
                    shotsAvailable: _rangedWeapon.shots.shotsAvailable,
                    reloadsBeforeCompleteReload:
                        parseInput(value, int.parse) ?? 0,
                  ),
                );
              },
              context: context,
            ),
          ),
        ],
      ),
      title: 'Shots',
      context: context,
    );
  }

  Widget _buildStSection() {
    return markAsGroup(
      child: Column(
        children: <Widget>[
          buildTextFormField(
            label: 'Strength value',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            allowsDecimal: false,
            defaultValue: widget.oldRangedWeapon?.range.maxRange.toString(),
            validator: validatePositiveNumber,
            onChanged: (String? value) {
              if (value == null) {
                return;
              }

              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                st: WeaponStrengths(
                  strengthValue: parseInput<int>(value, int.parse) ?? 0,
                ),
              );
            },
            context: context,
          ),
          const Gap(8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Is Two Handed',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Switch.adaptive(
                    value: _rangedWeapon.st.isTwoHanded ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        _rangedWeapon = RangedWeapon.copyWith(
                          _rangedWeapon,
                          st: WeaponStrengths(
                            strengthValue: _rangedWeapon.st.strengthValue,
                            hasBonusForHigherStrength:
                                _rangedWeapon.st.hasBonusForHigherStrength,
                            isTwoHanded: value,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Has bonus for higher ST',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Switch.adaptive(
                    value: _rangedWeapon.st.hasBonusForHigherStrength ?? false,
                    onChanged: (bool value) {
                      setState(() {
                        _rangedWeapon = RangedWeapon.copyWith(
                          _rangedWeapon,
                          st: WeaponStrengths(
                            strengthValue: _rangedWeapon.st.strengthValue,
                            isTwoHanded: _rangedWeapon.st.isTwoHanded,
                            hasBonusForHigherStrength: value,
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      title: 'Weapon Strength',
      context: context,
    );
  }

  void onAttackTypeChanged(AttackTypes? value) {
    if (value == null) {
      return;
    }

    final WeaponDamage newWeaponDamage = WeaponDamage(
      attackType: value,
      modifier: _rangedWeapon.damage.modifier,
      damageType: _rangedWeapon.damage.damageType,
    );

    _rangedWeapon = RangedWeapon.copyWith(
      _rangedWeapon,
      damage: newWeaponDamage,
    );
  }

  void onDamageTypeChanged(DamageType? value) {
    if (value == null) {
      return;
    }

    final WeaponDamage newWeaponDamage = WeaponDamage(
      attackType: _rangedWeapon.damage.attackType,
      modifier: _rangedWeapon.damage.modifier,
      damageType: value,
    );

    _rangedWeapon = RangedWeapon.copyWith(
      _rangedWeapon,
      damage: newWeaponDamage,
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
            initialValue: widget.oldRangedWeapon?.damage.attackType,
            items: attackTypesItems,
            onChanged: onAttackTypeChanged,
            context: context,
          ),
          const Gap(16),
          buildTextFormField(
            label: 'weapon damage modifier',
            keyboardType: TextInputType.number,
            allowsDecimal: false,
            defaultValue: widget.oldRangedWeapon?.damage.modifier.toString(),
            validator: validateWoleNumber,
            onChanged: (String? value) {
              if (value == null) {
                return;
              }

              final WeaponDamage newWeaponDamage = WeaponDamage(
                attackType: _rangedWeapon.damage.attackType,
                modifier: parseInput<int>(value, int.parse) ?? 0,
                damageType: _rangedWeapon.damage.damageType,
              );

              _rangedWeapon = RangedWeapon.copyWith(
                _rangedWeapon,
                damage: newWeaponDamage,
              );
            },
            context: context,
          ),
          const Gap(16),
          buildFormDropdownMenu(
            hint: 'Damage type',
            initialValue: widget.oldRangedWeapon?.damage.damageType,
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
