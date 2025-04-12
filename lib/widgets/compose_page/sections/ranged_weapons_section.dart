import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/legality_class.dart';
import 'package:gurps_character_creation/models/gear/weapons/ranged_weapon.dart';
import 'package:gurps_character_creation/services/character/providers/character_provider.dart';
import 'package:gurps_character_creation/services/gear/weapon_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/ranged_weapon_details_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/ranged_weapon_editor_dialog.dart';
import 'package:provider/provider.dart';

class RangedWeaponsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;
  final Character character;
  final CharacterWeaponProvider weaponProvider;

  const RangedWeaponsSection({
    super.key,
    required this.character,
    required this.weaponProvider,
  });

  DataRow _buildRangedWeaponDataCell(RangedWeapon rw, BuildContext context) {
    Iterable<DataCell> cells = rw.toDataTableColumns().entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          final Map<String, dynamic> json = e.value;
          if (Range.isRange(json)) {
            return DataCell(
              Text(
                Range.fromJson(json).toString(),
              ),
            );
          }

          if (WeaponStrengths.isWeaponStrengths(json)) {
            return DataCell(
              Text(
                WeaponStrengths.fromJson(json).toString(),
              ),
            );
          }

          if (RangeWeaponShots.isShots(json)) {
            return DataCell(
              Text(
                RangeWeaponShots.fromJson(json).toString(),
              ),
            );
          }
        }

        if (e.value is String) {
          final LegalityClass legalityClass =
              LegalityClassExtention.fromString(e.value);

          if (legalityClass != LegalityClass.NONE) {
            return DataCell(Text(legalityClass.stringValue));
          }
        }

        return DataCell(Center(
          child: Text(
            e.value is String ? e.value : e.value.toString(),
          ),
        ));
      },
    ).toList();

    return DataRow(cells: [
      ...cells,
      DataCell(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () => _openEditDialog(rw, context),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => weaponProvider.delete(rw.id),
              icon: const Icon(Icons.remove_outlined),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => RangedWeaponDetailsDialog(rw: rw),
              ),
              icon: const Icon(Icons.info_outlined),
            ),
          ],
        ),
      )
    ]);
  }

  Widget _buildAddNewItem(
    BuildContext context,
    CharacterProvider characterProvider,
  ) {
    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        const Text('Click to add a Ranged Weapon'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    if (characterProvider.character.weapons.whereType<RangedWeapon>().isEmpty) {
      return _buildAddNewItem(context, characterProvider);
    }

    return Column(
      children: [
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                ...RangedWeapon.empty().toDataTableColumns().keys.map(
                      (String key) => DataColumn(
                        label: Text(key),
                      ),
                    ),
                const DataColumn(label: Text('Actions')),
              ],
              rows: characterProvider.character.weapons
                  .whereType<RangedWeapon>()
                  .map(
                    (RangedWeapon rw) => _buildRangedWeaponDataCell(
                      rw,
                      context,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        _buildAddNewItem(context, characterProvider),
      ],
    );
  }

  void _openCreateDialog(BuildContext context) async {
    RangedWeapon? rw = await showDialog<RangedWeapon?>(
      context: context,
      builder: (context) => const RangedWeaponEditorDialog(),
    );

    if (rw != null) {
      weaponProvider.create(rw);
    }
  }

  void _openEditDialog(RangedWeapon rw, BuildContext context) async {
    RangedWeapon? newWeapon = await showDialog<RangedWeapon?>(
      context: context,
      builder: (context) => RangedWeaponEditorDialog(
        oldRangedWeapon: rw,
      ),
    );

    if (newWeapon != null) {
      weaponProvider.update(newWeapon);
    }
  }
}
