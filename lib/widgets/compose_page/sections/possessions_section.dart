import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/possession_detail_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/possession_editor_dialog.dart';
import 'package:provider/provider.dart';

class PosessionsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  const PosessionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final List<DataColumn> dataColumns = [
      ...Posession.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = characterProvider.character.possessions
        .map(
          (Posession poss) => _buildPossessionDataCell(
            context,
            poss,
            characterProvider,
          ),
        )
        .toList();

    if (dataRows.isEmpty) {
      return _buildAddNewItem(context, characterProvider);
    }

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
          _buildAddNewItem(context, characterProvider)
        ],
      ),
    );
  }

  DataRow _buildPossessionDataCell(
    BuildContext context,
    Posession poss,
    CharacterProvider characterProvider,
  ) {
    Iterable<DataCell> cells = poss.dataTableColumns.entries.map(
      (MapEntry<String, dynamic> e) {
        return DataCell(
          Center(
            child: Text(
              e.value.toString(),
            ),
          ),
        );
      },
    );

    return DataRow(
      cells: [
        ...cells,
        DataCell(
          _buildPossessionActions(
            context,
            poss,
            characterProvider,
          ),
        )
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    Posession? newPossession = await showDialog<Posession?>(
      context: context,
      builder: (context) => const PossessionEditorDialog(),
    );

    if (newPossession != null) {
      characterProvider.addPossession(newPossession);
    }
  }

  void _openEditDialog(
    Posession poss,
    BuildContext context,
    CharacterProvider characterProvider,
  ) async {
    Posession? newPossession = await showDialog<Posession?>(
      context: context,
      builder: (context) => PossessionEditorDialog(
        oldPossession: poss,
      ),
    );

    if (newPossession != null) {
      characterProvider.updatePossession(newPossession);
    }
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
        const Text('Click to add a Possession'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context, characterProvider),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildPossessionActions(
    BuildContext context,
    Posession poss,
    CharacterProvider characterProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(poss, context, characterProvider),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => characterProvider.removePossession(poss),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (context) => PossessionDetailsDialog(possession: poss),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}
