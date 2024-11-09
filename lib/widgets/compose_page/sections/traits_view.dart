import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait.dart';
import 'package:gurps_character_creation/models/characteristics/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';
import 'package:provider/provider.dart';

class ComposePageTraitsView extends StatelessWidget {
  final Widget Function(List<String> categories) emptyListBuilder;

  const ComposePageTraitsView({super.key, required this.emptyListBuilder});

  Widget _generateTraitView(
    List<TraitCategories> categories,
    CharacterProvider characterProvider,
  ) {
    final Iterable<Trait> traits = characterProvider.character.traits.where(
      (trait) => trait.categories.any(
        (category) => categories.contains(category),
      ),
    );

    if (traits.isEmpty) {
      return emptyListBuilder(
        List.from(categories.map((TraitCategories tc) => tc.stringValue)),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.from(traits.map(
        (Trait t) => TraitView(
          trait: t,
          onRemoveClick: () => characterProvider.removeTrait(t),
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final List<Widget> children = [
      _generateTraitView(
        [TraitCategories.ADVANTAGE, TraitCategories.PERK],
        characterProvider,
      ),
      _generateTraitView(
        [TraitCategories.ADVANTAGE, TraitCategories.PERK],
        characterProvider,
      ),
    ];

    if (isMobile) {
      return Column(
        children: children,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: children,
    );
  }
}
