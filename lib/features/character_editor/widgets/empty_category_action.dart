import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_aspects_filter_provider.dart';
import 'package:gurps_character_creation/features/character_editor/sidebar/providers/sidebar_provider.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';
import 'package:provider/provider.dart';

class EmptyCategoryAction extends StatelessWidget {
  static const double _DIVIDER_INDENT = 32;

  final List<String> categories;
  const EmptyCategoryAction({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    final String types = categories.join('/');
    final SidebarProvider sidebarProvider = context.read<SidebarProvider>();
    final SidebarAspectsFilterProvider sidebarFilter =
        context.read<SidebarAspectsFilterProvider>();

    return Column(
      children: [
        const Divider(
          endIndent: _DIVIDER_INDENT,
          indent: _DIVIDER_INDENT,
        ),
        Text('Click to add $types '),
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: IconButton.filled(
            onPressed: () {
              sidebarFilter.clearFilters();

              if (!sidebarProvider.isSidebarVisible) {
                sidebarProvider.toggleSidebar(context);
              }

              AspectsFutureTypes sidebarContent =
                  SidebarFutureTypesStringExtension.fromString(types);

              sidebarFilter.sidebarContent = sidebarContent;

              if (sidebarContent == AspectsFutureTypes.TRAITS) {
                categories
                    .map((String c) => setTraitCategories(c, sidebarFilter))
                    .toList();
              }
            },
            icon: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  void setTraitCategories(
      String c, SidebarAspectsFilterProvider sidebarFilter) {
    TraitCategories category = TraitCategoriesExtension.fromString(c);

    if (!sidebarFilter.selectedTraitCategories.contains(category)) {
      sidebarFilter.addSelectedTraitCategory(category);
    }
  }
}
