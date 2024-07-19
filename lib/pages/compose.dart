import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/models/traits/trait_categories.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';

class ComposePage extends StatefulWidget {
  const ComposePage({super.key});

  @override
  State<ComposePage> createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {
  bool _isSidebarVisible = true;

  String _filterValue = '';

  TraitCategories selectedCategory = TraitCategories.NONE;

  Widget get _skillsIconButton => Expanded(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                print('Skills');
              },
              icon: const Icon(
                Icons.handyman_sharp,
              ),
            ),
            const Text(
              'Skills',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      );

  Widget get _magicSpellsIconButton => Expanded(
        child: Column(
          children: [
            IconButton(
              onPressed: () {
                print('Magic');
              },
              icon: const Icon(
                Icons.bolt_rounded,
              ),
            ),
            const Text(
              'Magic',
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      );

  void onFilterButtonPressed(TraitCategories category) {
    setState(() {
      if (selectedCategory == category) {
        selectedCategory = TraitCategories.NONE;
        return;
      }

      selectedCategory = category;
    });
  }

  Widget get _filters => Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.spaceAround,
        runSpacing: 0,
        spacing: 24,
        children: [
          ...TraitCategories.values.map(
            (category) => Expanded(
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      category.iconValue,
                      size: 24,
                    ),
                    onPressed: () => onFilterButtonPressed(category),
                  ),
                  Text(
                    category.stringValue,
                    style: const TextStyle(fontSize: 12),
                  )
                ],
              ),
            ),
          ),
          // _skillsIconButton,
          // _magicSpellsIconButton
        ],
      );

  Widget get _filterSearchField => TextField(
        onChanged: (value) => setState(() {
          _filterValue = value;
        }),
        decoration: InputDecoration(labelText: 'Filter'),
      );

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Compose'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
        actions: [
          CustomButton(
            child: const Icon(Icons.now_widgets_rounded),
            onPressed: () => setState(() {
              _isSidebarVisible = !_isSidebarVisible;
            }),
          ),
        ],
      ),
      body: ComposePageLayout(
        isSidebarVisible: _isSidebarVisible,
        sidebarContent: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4,
                ),
                child: Column(
                  children: [
                    _filters,
                    _filterSearchField,
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Trait>>(
                future: loadTraits(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No data found.'));
                  }

                  // final List<Skill> skills = snapshot.data!;
                  final List<Trait> traits = snapshot.data!
                      .where(
                        (element) => selectedCategory == TraitCategories.NONE
                            ? true
                            : element.categories.contains(selectedCategory),
                      )
                      .where(
                        (element) => element.name
                            .toLowerCase()
                            .contains(_filterValue.toLowerCase()),
                      )
                      .toList();
                  return ListView.builder(
                    itemCount: traits.length,
                    itemBuilder: (context, index) =>
                        TraitView(trait: traits[index]),
                  );
                },
              ),
            ),
          ],
        ),
        bodyContent: const Placeholder(),
      ),
    );
  }
}
