import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/gear/damage_type.dart';
import 'package:gurps_character_creation/models/gear/ranged_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapon_damage.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/utilities/dialog_size.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
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
    if (widget.oldRangedWeapon == null) {
      super.initState();
      return;
    }

    _rangedWeapon = widget.oldRangedWeapon!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxHeight = MediaQuery.of(context).size.height / 1.5;
    final bool isMobile = screenWidth <= MAX_MOBILE_WIDTH;

    Widget body = AlertDialog.adaptive(
      title: _buildTitle(),
      shape: dialogShape,
      actions: _buildActions(context),
      scrollable: true,
      content: SingleChildScrollView(
        child: _buildForm(),
      ),
    );

    if (isMobile) {
      return body;
    }

    return Center(
      child: SizedBox(
        width: min(screenWidth / 1.5, MAX_DESKTOP_CONTENT_WIDTH / 1.5),
        height: maxHeight,
        child: body,
      ),
    );
  }

  Widget _buildTitle() {
    if (_rangedWeapon.name == '') {
      return const Text('New Weapon');
    }

    return Text(_rangedWeapon.name);
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
          if (_formkey.currentState!.validate()) {
            Navigator.pop(context, _rangedWeapon);
          }
        },
        label: const Text('add'),
      ),
    ];
  }

  Widget _buildForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          ..._buildBaseInfoSection(),
          const Gap(16),
          _buildDamageSection(),
          const Gap(16),
          _buildStSection(),
          const Gap(16),
          _buildRangeSection(),
          const Gap(16),
          _buildShotsSection(),
        ],
      ),
    );
  }

  List<Widget> _buildBaseInfoSection() {
    const String MIN_ST_EXPLANATION =
        'All RangedWeapons in GURPS have a minimum Strength required to wield them\nIf your character ST is lower than this parametre — they will receive a penalty to any check for the weapon equal to: Character ST - Minimum ST';

    final List<DropdownMenuItem<String>> assosiatedSkillsItems =
        Provider.of<AspectsProvider>(context)
            .skills
            .map(
              (Skill skl) => DropdownMenuItem(
                value: skl.name,
                child: Text(skl.name),
              ),
            )
            .toList();

    return [
      buildTextFormField(
        label: 'Name of the weapon',
        defaultValue: widget.oldRangedWeapon?.name,
        validator: validateText,
        onChanged: (value) {
          if (value == null) {
            return;
          }
          setState(() {
            _rangedWeapon = RangedWeapon.copyWith(_rangedWeapon, name: value);
          });
        },
        context: context,
      ),
      const Gap(12),
      buildTextFormField(
        keyboardType: TextInputType.number,
        allowsDecimal: true,
        defaultValue: widget.oldRangedWeapon?.weight.toString(),
        label: 'Weight of the weapon',
        validator: validateNumber,
        onChanged: (value) {
          if (value == null) {
            return;
          }

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            weight: parseInput<double>(value, double.parse),
          );
        },
        context: context,
      ),
      const Gap(12),
      buildTextFormField(
        keyboardType: TextInputType.number,
        allowsDecimal: true,
        defaultValue: widget.oldRangedWeapon?.price.toString(),
        label: 'Price of the weapon',
        validator: validateNumber,
        onChanged: (value) {
          if (value == null) {
            return;
          }

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            price: parseInput<double>(value, double.parse),
          );
        },
        context: context,
      ),
      const Gap(24),
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
      const Gap(8),
      Text(
        MIN_ST_EXPLANATION,
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(24),
      buildFormDropdownMenu<String>(
        hint: 'Associated skill',
        initialValue: widget.oldRangedWeapon?.associatedSkillName,
        items: assosiatedSkillsItems,
        onChanged: (String? value) {
          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            associatedSkillName: value,
          );
        },
        context: context,
      ),
      const Gap(8),
      Text(
        'Any weapon has a skill attached that determines how successfull you parry and hit with a given weapon',
        style: Theme.of(context).textTheme.labelSmall,
      ),
      const Gap(16),
      buildFormDropdownMenu<RangedWeaponLegalityClass>(
        hint: 'Legality Class',
        initialValue: widget.oldRangedWeapon?.lc,
        items: RangedWeaponLegalityClass.values
            .where(
              (lc) => lc != RangedWeaponLegalityClass.NONE,
            )
            .map(
              (RangedWeaponLegalityClass lc) => DropdownMenuItem(
                value: lc,
                child: Text(lc.stringValue),
              ),
            )
            .toList(),
        onChanged: (RangedWeaponLegalityClass? value) {
          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            lc: value,
          );
        },
        context: context,
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

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            accuracy: parseInput<int>(value, int.parse),
          );
        },
        context: context,
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

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            rateOfFire: parseInput<int>(value, int.parse),
          );
        },
        context: context,
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

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            bulk: parseInput<int>(value, int.parse),
          );
        },
        context: context,
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

          _rangedWeapon = RangedWeapon.copyWith(
            _rangedWeapon,
            recoil: parseInput<int>(value, int.parse),
          );
        },
        context: context,
      ),
    ];
  }

  Widget _buildRangeSection() {
    return markAsGroup(
      child: Row(
        children: [
          Expanded(
            child: buildTextFormField(
              label: 'Short Range',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldRangedWeapon?.range.shortRange.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  range: Range(
                    shortRange: parseInput<int>(value, int.parse) ?? 0,
                  ),
                );
              },
              context: context,
            ),
          ),
          const Gap(16),
          Expanded(
            child: buildTextFormField(
              label: 'Long Range',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: false,
              ),
              allowsDecimal: false,
              defaultValue: widget.oldRangedWeapon?.range.longRange.toString(),
              validator: validatePositiveNumber,
              onChanged: (String? value) {
                if (value == null) {
                  return;
                }

                _rangedWeapon = RangedWeapon.copyWith(
                  _rangedWeapon,
                  range: Range(
                    shortRange: _rangedWeapon.range.shortRange,
                    longRange: parseInput<int>(value, int.parse) ?? 0,
                  ),
                );
              },
              context: context,
            ),
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
              defaultValue: widget.oldRangedWeapon?.range.shortRange.toString(),
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
              defaultValue: widget.oldRangedWeapon?.range.longRange.toString(),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildTextFormField(
            label: 'Strength value',
            keyboardType: const TextInputType.numberWithOptions(
              decimal: false,
            ),
            allowsDecimal: false,
            defaultValue: widget.oldRangedWeapon?.range.longRange.toString(),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
          'Any weapon has an attack type (Thrust or Swing). The Swing damage is higher since the weapon functions as a lever in that case\n\nAny weapon has some modifier on top of the basic throw. For example Thr+2 means you pick a Thrusting throw from the table and add 2\n\nAnd damage type is self explainatory',
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
