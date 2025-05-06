import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/features/equipment/models/armor.dart';
import 'package:gurps_character_creation/features/equipment/providers/armor_provider.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/details/armor_details_dialog.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/equipment/armor_editor_dialog.dart';

class ArmorSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;
  final ArmorProvider armorProvider;

  const ArmorSection({
    super.key,
    required this.armorProvider,
  });

  Future<void> _openCreateDialog(BuildContext context) async {
    Armor? armor = await context.showAdaptiveDialog(
      builder: (context) => const ArmorEditorDialog(),
    );

    if (armor != null) {
      armorProvider.create(armor);
    }
  }

  void _openEditDialog(
    Armor armor,
    BuildContext context,
  ) async {
    Armor? newArmor = await context.showAdaptiveDialog<Armor?>(
      builder: (context) => ArmorEditorDialog(
        oldArmor: armor,
      ),
    );

    if (newArmor != null) {
      armorProvider.update(newArmor);
    }
  }

  DataCell _buildMapValueCell(Map<String, dynamic> value, Armor armor) {
    if (DamageResistance.isDamageResistance(value)) {
      return DataCell(
        Text(DamageResistance.fromJson(value).GURPSNotation),
      );
    }

    return const DataCell(Text(''));
  }

  DataRow _buildArmorDataCell(BuildContext context, Armor armor) {
    Iterable<DataCell> cells = armor.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          return _buildMapValueCell(e.value, armor);
        }

        if (BodyPartString.fromString(e.value.toString()) != BodyPart.NONE) {
          DataCell(
            Center(
              child: Text(
                  BodyPartString.fromString(e.value.toString()).stringValue),
            ),
          );
        }

        return DataCell(
          Center(
            child: Text(e.value.toString()),
          ),
        );
      },
    );

    return DataRow(cells: [
      ...cells,
      DataCell(
        _buildArmorActions(context, armor),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (armorProvider.readAll().isEmpty) {
      return _buildAddNewItem(context);
    }

    final List<DataColumn> dataColumns = [
      ...Armor.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = armorProvider
        .readAll()
        .map(
          (Armor armor) => _buildArmorDataCell(context, armor),
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

  Widget _buildAddNewItem(BuildContext context) {
    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        const Text('Click to add an Armor'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildArmorActions(BuildContext context, Armor armor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(armor, context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => armorProvider.delete(armor.id),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => context.showAdaptiveDialog(
            builder: (context) => ArmorDetailsDialog(armor: armor),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}
