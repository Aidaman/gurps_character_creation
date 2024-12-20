import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:provider/provider.dart';

class ComposePageArmorSection extends StatelessWidget {
  const ComposePageArmorSection({super.key});

  Widget _buildArmorActions(
    BuildContext context,
    Armor armor,
    CharacterProvider characterProvider,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined),
        ),
        IconButton(
          onPressed: () => characterProvider.removeArmor(armor),
          icon: const Icon(Icons.remove_outlined),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.info_outline),
        ),
      ],
    );
  }

  void _openCreateDialog(
    BuildContext context,
    CharacterProvider characterProvider,
  ) {}

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    // final List<DataColumn> dataColumns = [
    //   ...Armor.empty().dataTableColumns.keys.map(
    //         (String key) => DataColumn(
    //           label: Text(key),
    //         ),
    //       ),
    //   const DataColumn(label: Text('Actions')),
    // ];

    return Center(
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // child: DataTable(
            //   columns: dataColumns,
            //   rows: dataRows,
            // ),
          ),
          IconButton.filled(
            onPressed: () => _openCreateDialog(context, characterProvider),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
