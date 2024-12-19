import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/characteristics/attributes.dart';
import 'package:gurps_character_creation/models/characteristics/skills/skill.dart';
import 'package:gurps_character_creation/models/gear/weapons/hand_weapon.dart';
import 'package:gurps_character_creation/models/gear/weapons/weapon_damage.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/hand_weapon_details_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/hand_weapon_editor_dialog.dart';
import 'package:provider/provider.dart';

class ComposePageHandWeaponsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  const ComposePageHandWeaponsSection({super.key});

  DataCell _buildMapValueCell(
    Map<String, dynamic> json,
    CharacterProvider characterProvider,
    HandWeapon hw,
  ) {
    if (HandWeaponReach.isReach(json)) {
      return DataCell(
        Text(HandWeaponReach.fromJson(json).toString()),
      );
    }

    if (WeaponDamage.isDamage(json)) {
      return DataCell(
        Text(
          WeaponDamage.fromJson(
            json,
          ).calculateDamage(
            characterProvider.character.getAttribute(Attributes.ST),
            hw.minimumSt,
          ),
        ),
      );
    }

    return const DataCell(Text(''));
  }

  DataRow _buildHandWeaponDataCell(
    BuildContext context,
    HandWeapon hw,
    CharacterProvider characterProvider,
  ) {
    Iterable<DataCell> cells = hw.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          return _buildMapValueCell(e.value, characterProvider, hw);
        }

        if (e.key == 'parry') {
          return _getParryCell(characterProvider, hw);
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
          characterProvider,
        ),
      )
    ]);
  }

  Widget _buildHandWeaponActions(
    BuildContext context,
    HandWeapon hw,
    CharacterProvider characterProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(hw, context, characterProvider),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => characterProvider.removeWeapon(hw),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => HandWeaponDetailsDialog(handWeapon: hw),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }

  DataCell _getParryCell(CharacterProvider characterProvider, HandWeapon hw) {
    int skillIndex = characterProvider.character.skills.indexWhere(
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

    Skill skill = characterProvider.character.skills.elementAt(skillIndex);

    int skillLevel = skill.skillLevel(
      characterProvider.character.getAttribute(skill.associatedAttribute),
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
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    if (characterProvider.character.weapons.whereType<HandWeapon>().isEmpty) {
      return _buildAddNewItem(context, characterProvider);
    }

    final List<DataColumn> dataColumns = [
      ...HandWeapon.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = characterProvider.character.weapons
        .whereType<HandWeapon>()
        .map(
          (HandWeapon hw) => _buildHandWeaponDataCell(
            context,
            hw,
            characterProvider,
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
          IconButton.filled(
            onPressed: () => _openCreateDialog(context, characterProvider),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Column _buildAddNewItem(
    BuildContext context,
    CharacterProvider characterProvider,
  ) {
    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        const Text('Click to add a Weapon'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context, characterProvider),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    HandWeapon? hw = await showDialog<HandWeapon?>(
      context: context,
      builder: (context) => const HandWeaponEditorDialog(),
    );

    if (hw != null) {
      characterProvider.addWeapon(hw);
    }
  }

  void _openEditDialog(
    HandWeapon hw,
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    HandWeapon? newWeapon = await showDialog<HandWeapon?>(
      context: context,
      builder: (context) => HandWeaponEditorDialog(
        oldHandWeapon: hw,
      ),
    );

    if (newWeapon != null) {
      characterProvider.updateWeapon(hw.id, newWeapon);
    }
  }
}
