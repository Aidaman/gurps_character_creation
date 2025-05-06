import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/consts.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_equipment_filter_provider.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/widgets/search_field.dart';
import 'package:gurps_character_creation/features/gear/providers/gear_provider.dart';
import 'package:gurps_character_creation/widgets/button/labeled_icon_button.dart';
import 'package:provider/provider.dart';

class SidebarEquipmentTab extends StatelessWidget {
  const SidebarEquipmentTab({super.key});

  @override
  Widget build(BuildContext context) {
    SidebarEquipmentFilterProvider filter =
        context.watch<SidebarEquipmentFilterProvider>();

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: SIDEBAR_HORIZONTAL_PADDING,
            vertical: SIDEBAR_VERTICAL_PADDING,
          ),
          child: Column(
            children: [
              _buildFilters(context),
              const Gap(16),
              SearchField(
                onSearchChanged: (value) {
                  filter.filterQuerry = value;
                },
              )
            ],
          ),
        ),
        const Gap(8),
        Expanded(
          child: _buildList(
            list: context.watch<GearProvider>().handWeapons,
            itemBuilder: (item) => Text(item.name),
            noDataText: 'No weapons found',
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    SidebarEquipmentFilterProvider filter =
        context.watch<SidebarEquipmentFilterProvider>();

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      runAlignment: WrapAlignment.spaceAround,
      spacing: FILTER_SPACING,
      runSpacing: FILTER_RUN_SPACING,
      children: EquipmentFilterTypes.values
          .map(
            (EquipmentFilterTypes type) => LabeledIconButton(
              iconValue: type.icon,
              label: type.abbreviatedStringValue,
              onPressed: () {
                filter.sidebarContent = type;
              },
              backgroundColor: filter.sidebarContent == type
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
          )
          .toList(),
    );
  }

  Widget _buildList<T>({
    required List<T> list,
    required Widget Function(T item) itemBuilder,
    required String noDataText,
    required BuildContext context,
    bool Function(T item)? filterPredicate,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Text(noDataText),
      );
    }

    if (filterPredicate != null) {
      list = list.where(filterPredicate).toList();
    }

    if (list.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            noDataText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Create your own thing!'),
          ),
        ],
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) => itemBuilder(
        list.elementAt(
          index,
        ),
      ),
    );
  }
}
