import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/armor_details_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/armor_editor_dialog.dart';
import 'package:provider/provider.dart';

class ArmorSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  const ArmorSection({super.key});

  Future<void> _openCreateDialog(
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    Armor? armor = await showDialog(
      context: context,
      builder: (context) => const ArmorEditorDialog(),
    );

    if (armor != null) {
      characterProvider.addArmor(armor);
    }
  }

  void _openEditDialog(
    Armor armor,
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    Armor? newArmor = await showDialog<Armor?>(
      context: context,
      builder: (context) => ArmorEditorDialog(
        oldArmor: armor,
      ),
    );

    if (newArmor != null) {
      characterProvider.updateArmor(newArmor);
    }
  }

  DataCell _buildMapValueCell(Map<String, dynamic> value,
      CharacterProvider characterProvider, Armor armor) {
    if (DamageResistance.isDamageResistance(value)) {
      return DataCell(
        Text(DamageResistance.fromJson(value).GURPSNotation),
      );
    }

    return const DataCell(Text(''));
  }

  DataRow _buildArmorDataCell(
    BuildContext context,
    Armor armor,
    CharacterProvider characterProvider,
  ) {
    Iterable<DataCell> cells = armor.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        final bool valueIsMap = e.value is Map;

        if (valueIsMap) {
          return _buildMapValueCell(e.value, characterProvider, armor);
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
        _buildArmorActions(
          context,
          armor,
          characterProvider,
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    if (characterProvider.character.armor.isEmpty) {
      return _buildAddNewItem(context, characterProvider);
    }

    final List<DataColumn> dataColumns = [
      ...Armor.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = characterProvider.character.armor
        .map(
          (Armor armor) => _buildArmorDataCell(
            context,
            armor,
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
          _buildAddNewItem(context, characterProvider),
        ],
      ),
    );
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
        const Text('Click to add an Armor'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context, characterProvider),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildArmorActions(
    BuildContext context,
    Armor armor,
    CharacterProvider characterProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(armor, context, characterProvider),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => characterProvider.removeArmor(armor),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => ArmorDetailsDialog(armor: armor),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}
