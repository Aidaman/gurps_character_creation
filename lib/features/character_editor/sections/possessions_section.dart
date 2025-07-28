import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/services/service_locator.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:gurps_character_creation/features/equipment/models/posession.dart';
import 'package:gurps_character_creation/features/equipment/providers/possessions_provider.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/details/possession_detail_dialog.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/equipment/possession_editor_dialog.dart';
import 'package:provider/provider.dart';

class PosessionsSection extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;
  final PossessionsProvider _possessionsProvider;

  const PosessionsSection({
    super.key,
    required PossessionsProvider possessionsProvider,
  }) : _possessionsProvider = possessionsProvider;

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
    Possession? newPossession = await context.showAdaptiveDialog<Possession?>(
      builder: (context) => const PossessionEditorDialog(),
    );

    if (newPossession != null) {
      _possessionsProvider.create(newPossession);
      serviceLocator.get<AutosaveService>().triggerAutosave();
    }
  }

  void _openEditDialog(Possession poss, BuildContext context) async {
    Possession? newPossession = await context.showAdaptiveDialog<Possession?>(
      builder: (context) => PossessionEditorDialog(
        oldPossession: poss,
      ),
    );

    if (newPossession != null) {
      _possessionsProvider.update(newPossession);
      serviceLocator.get<AutosaveService>().triggerAutosave();
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
          onPressed: () {
            _possessionsProvider.delete(poss.id);
            serviceLocator.get<AutosaveService>().triggerAutosave();
          },
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () => context.showAdaptiveDialog(
            builder: (context) => PossessionDetailsDialog(possession: poss),
          ),
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }
}
