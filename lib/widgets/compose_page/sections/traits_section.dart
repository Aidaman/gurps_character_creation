import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/select_trait_modifiers.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';
import 'package:provider/provider.dart';

class TraitsSection extends StatelessWidget {
  final Widget Function(List<String> categories) emptyListBuilder;

  const TraitsSection({super.key, required this.emptyListBuilder});

  void Function()? _generateChangeModifiers(
    BuildContext context,
    Trait trt,
    CharacterProvider characterProvider,
  ) {
    if (trt.modifiers.isEmpty) {
      return null;
    }

    return () async {
      characterProvider.removeTrait(trt);
      characterProvider.addTrait(
        Trait.copyWIth(
          trt,
          selectedModifiers: await showDialog(
            context: context,
            builder: (context) => SelectTraitModifiersDialog(trait: trt),
          ),
        ),
      );
    };
  }

  Widget _generateTraitView(
    BuildContext context,
    List<TraitCategories> categories,
    CharacterProvider characterProvider,
  ) {
    final Iterable<Trait> traits = characterProvider.character.traits.where(
      (Trait trait) => categories.contains(trait.category),
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
          onChangeModifiersClick: _generateChangeModifiers(
            context,
            t,
            characterProvider,
          ),
          onChangePlaceholderClick: () async =>
              characterProvider.updateTraitTitle(
            t,
            await characterProvider.replacePlacholderName(context, t.name),
          ),
          onIncreaseLevel:
              t.canLevel ? () => characterProvider.increaseTraitLevel(t) : null,
          onReduceLevel:
              t.canLevel ? () => characterProvider.reduceTraitLevel(t) : null,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    if (isMobile) {
      return Column(
        children: [
          _generateTraitView(
            context,
            [TraitCategories.ADVANTAGE, TraitCategories.PERK],
            characterProvider,
          ),
          _generateTraitView(
            context,
            [TraitCategories.DISADVANTAGE, TraitCategories.QUIRK],
            characterProvider,
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _generateTraitView(
            context,
            [TraitCategories.ADVANTAGE, TraitCategories.PERK],
            characterProvider,
          ),
        ),
        Expanded(
          child: _generateTraitView(
            context,
            [TraitCategories.DISADVANTAGE, TraitCategories.QUIRK],
            characterProvider,
          ),
        ),
      ],
    );
  }
}
