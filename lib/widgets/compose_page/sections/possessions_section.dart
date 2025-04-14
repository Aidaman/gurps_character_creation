import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';
import 'package:gurps_character_creation/services/gear/possessions_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/possession_detail_dialog.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/gear/possession_editor_dialog.dart';
import 'package:provider/provider.dart';

class PosessionsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  final Character _character;
  final PossessionsProvider _possessionsProvider;

  const PosessionsSection({
    super.key,
    required Character character,
    required PossessionsProvider possessionsProvider,
  })  : _character = character,
        _possessionsProvider = possessionsProvider;

  @override
  Widget build(BuildContext context) {
    final List<DataColumn> dataColumns = [
      ...Possession.empty().dataTableColumns.keys.map(
            (String key) => DataColumn(
              label: Text(key),
            ),
          ),
      const DataColumn(label: Text('Actions')),
    ];

    final List<DataRow> dataRows = context
        .read<PossessionsProvider>()
        .readAll()
        .map(
          (Possession poss) => _buildPossessionDataCell(context, poss),
        )
        .toList();

    if (dataRows.isEmpty) {
      return _buildAddNewItem(context);
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
          _buildAddNewItem(context)
        ],
      ),
    );
  }

  DataRow _buildPossessionDataCell(BuildContext context, Possession poss) {
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
          _buildPossessionActions(context, poss),
        )
      ],
    );
  }

  void _openCreateDialog(BuildContext context) async {
    Possession? newPossession = await showDialog<Possession?>(
      context: context,
      builder: (context) => const PossessionEditorDialog(),
    );

    if (newPossession != null) {
      _possessionsProvider.create(newPossession);
    }
  }

  void _openEditDialog(Possession poss, BuildContext context) async {
    Possession? newPossession = await showDialog<Possession?>(
      context: context,
      builder: (context) => PossessionEditorDialog(
        oldPossession: poss,
      ),
    );

    if (newPossession != null) {
      _possessionsProvider.update(newPossession);
    }
  }

  Widget _buildAddNewItem(BuildContext context) {
    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        const Text('Click to add a Possession'),
        IconButton.filled(
          onPressed: () => _openCreateDialog(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  Widget _buildPossessionActions(BuildContext context, Possession poss) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _openEditDialog(poss, context),
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => _possessionsProvider.delete(poss.id),
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
