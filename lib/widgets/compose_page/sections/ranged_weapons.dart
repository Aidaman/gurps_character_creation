import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/gear/ranged_weapon.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/ranged_weapon_details_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/ranged_weapon_editor_dialog.dart';
import 'package:provider/provider.dart';

class ComposePageRangedWeaponsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  const ComposePageRangedWeaponsSection({super.key});

  DataRow _buildRangedWeaponDataCell(
    RangedWeapon rw,
    CharacterProvider characterProvider,
    BuildContext context,
  ) {
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
          final RangedWeaponLegalityClass legalityClass =
              RangedWeaponLegalityClassExtention.fromString(e.value);

          if (legalityClass != RangedWeaponLegalityClass.NONE) {
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
              onPressed: () => _openEditDialog(rw, context, characterProvider),
              icon: const Icon(Icons.edit_outlined),
            ),
            IconButton(
              onPressed: () => characterProvider.removeWeapon(rw),
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

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    if (characterProvider.character.weapons.whereType<RangedWeapon>().isEmpty) {
      return Column(
        children: [
          const Divider(
            endIndent: _DIVIDER_INDENT,
            indent: _DIVIDER_INDENT,
          ),
          const Text('Click to add a Ranged Weapon'),
          IconButton.filled(
            onPressed: () => _openCreateDialog(context, characterProvider),
            icon: const Icon(Icons.add),
          ),
        ],
      );
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
                      characterProvider,
                      context,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        IconButton.filled(
          onPressed: () {
            characterProvider.addWeapon(RangedWeapon.empty());
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    RangedWeapon? rw = await showDialog<RangedWeapon?>(
      context: context,
      builder: (context) => const RangedWeaponEditorDialog(),
    );

    if (rw != null) {
      characterProvider.addWeapon(rw);
    }
  }

  void _openEditDialog(
    RangedWeapon rw,
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    RangedWeapon? newWeapon = await showDialog<RangedWeapon?>(
      context: context,
      builder: (context) => RangedWeaponEditorDialog(
        oldRangedWeapon: rw,
      ),
    );

    if (newWeapon != null) {
      characterProvider.updateWeapon(rw.id, newWeapon);
    }
  }
}
