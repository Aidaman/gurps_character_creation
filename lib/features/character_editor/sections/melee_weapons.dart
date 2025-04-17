import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/features/character/models/attributes.dart';
import 'package:gurps_character_creation/features/skills/models/skill.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/gear/models/legality_class.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/features/gear/models/weapons/weapon_damage.dart';
import 'package:gurps_character_creation/features/gear/providers/weapon_provider.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/details/hand_weapon_details_dialog.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/gear/hand_weapon_editor_dialog.dart';

class MeleeWeaponsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;
  final Character character;
  final CharacterWeaponProvider weaponProvider;

  const MeleeWeaponsSection({
    super.key,
    required this.character,
    required this.weaponProvider,
  });

  DataCell _buildMapValueCell(
    Map<String, dynamic> json,
    HandWeapon hw,
  ) {
    if (HandWeaponReach.isReach(json)) {
      return DataCell(
        Text(HandWeaponReach.fromJson(json).toString()),
      );
    }

    if (WeaponDamage.isDamage(json)) {
      WeaponDamage damage = WeaponDamage.fromJson(json);

      return DataCell(
        Text(damage.calculateDamage(
          character.attributes.getAttribute(Attributes.ST),
          hw.minimumSt,
        )),
      );
    }

    return const DataCell(Text(''));
  }

  DataCell _getLegalityClassCell(MapEntry<String, dynamic> e) {
    return DataCell(
      Center(
        child: Text(
          (e.value as LegalityClass).stringValue,
        ),
      ),
    );
  }

  DataRow _buildHandWeaponDataCell(BuildContext context, HandWeapon hw) {
    Iterable<DataCell> cells = hw.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          return _buildMapValueCell(e.value, hw);
        }

        if (e.key == 'parry') {
          return _getParryCell(hw);
        }

        if (e.key == 'lc' && e.value is LegalityClass) {
          return _getLegalityClassCell(e);
        }

        return DataCell(
          Center(
            child: Text(
              e.value is String ? e.value : e.value.toString(),
            ),
          ),
        );
      },
    );

    return DataRow(cells: [
      ...cells,
      DataCell(
        _buildHandWeaponActions(
          context,
          hw,
        ),
      )
    ]);
  }

  Widget _buildHandWeaponActions(BuildContext context, HandWeapon hw) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(hw, context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => weaponProvider.delete(hw.id),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => context.showAdaptiveDialog(
            builder: (context) => HandWeaponDetailsDialog(handWeapon: hw),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }

  DataCell _getParryCell(HandWeapon hw) {
    int skillIndex = character.skills.indexWhere(
      (Skill skl) => skl.name == hw.associatedSkillName,
    );

    if (skillIndex == -1) {
      return DataCell(
        Center(
          child: Text(
            HandWeapon.calculateParry(0).toString(),
          ),
        ),
      );
    }

    Skill skill = character.skills.elementAt(skillIndex);

    int skillLevel = skill.skillLevel(
      character.attributes.getAttribute(skill.associatedAttribute),
    );

    return DataCell(
      Center(
        child: Text(
          HandWeapon.calculateParry(skillLevel).toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (character.weapons.whereType<HandWeapon>().isEmpty) {
      return _buildAddNewItem(context);
    }

    final List<DataColumn> dataColumns = [
      ...HandWeapon.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = character.weapons
        .whereType<HandWeapon>()
        .map(
          (HandWeapon hw) => _buildHandWeaponDataCell(
            context,
            hw,
          ),
        )
        .toList();

    return Center(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: dataColumns,
              rows: dataRows,
            ),
          ),
          _buildAddNewItem(context),
        ],
      ),
    );
  }

  Column _buildAddNewItem(BuildContext context) {
    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        const Text('Click to add a Weapon'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _openCreateDialog(BuildContext context) async {
    HandWeapon? hw = await context.showAdaptiveDialog<HandWeapon?>(
      builder: (context) => const HandWeaponEditorDialog(),
    );

    if (hw != null) {
      weaponProvider.create(hw);
    }
  }

  void _openEditDialog(HandWeapon hw, BuildContext context) async {
    HandWeapon? newWeapon = await context.showAdaptiveDialog<HandWeapon?>(
      builder: (context) => HandWeaponEditorDialog(
        oldHandWeapon: hw,
      ),
    );

    if (newWeapon != null) {
      weaponProvider.update(newWeapon);
    }
  }
}
