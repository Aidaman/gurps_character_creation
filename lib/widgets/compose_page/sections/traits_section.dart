import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait_categories.dart';
import 'package:gurps_character_creation/providers/character/traits_provider.dart';
import 'package:gurps_character_creation/widgets/compose_page/dialogs/select_trait_modifiers.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';

class TraitsSection extends StatelessWidget {
  final Widget Function(List<String> categories) emptyListBuilder;
  final TraitsProvider _traitsProvider;

  const TraitsSection({
    super.key,
    required this.emptyListBuilder,
    required TraitsProvider traitsProvider,
  }) : _traitsProvider = traitsProvider;

  void Function()? _generateChangeModifiers(BuildContext context, Trait trt) {
    if (trt.modifiers.isEmpty) {
      return null;
    }

    return () async {
      _traitsProvider.delete(trt);
      _traitsProvider.add(
        Trait.copyWIth(
          trt,
          selectedModifiers: await context.showAdaptiveDialog(
            builder: (context) => SelectTraitModifiersDialog(trait: trt),
          ),
        ),
      );
    };
  }

  Widget _generateTraitView(
    BuildContext context,
    List<TraitCategories> categories,
  ) {
    final Iterable<Trait> traits =
        _traitsProvider.readAllOfMultipleCategories(categories);

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
          onRemoveClick: () => _traitsProvider.delete(t),
          onChangeModifiersClick: _generateChangeModifiers(context, t),
          onChangePlaceholderClick: () async =>
              await _traitsProvider.updateTraitTitle(t, context),
          onIncreaseLevel: t.canLevel
              ? () => _traitsProvider.updateTraitLevel(t, doIncrease: true)
              : null,
          onReduceLevel: t.canLevel
              ? () => _traitsProvider.updateTraitLevel(t, doIncrease: false)
              : null,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    if (isMobile) {
      return Column(
        children: [
          _generateTraitView(
            context,
            [TraitCategories.ADVANTAGE, TraitCategories.PERK],
          ),
          _generateTraitView(
            context,
            [TraitCategories.DISADVANTAGE, TraitCategories.QUIRK],
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
          ),
        ),
        Expanded(
          child: _generateTraitView(
            context,
            [TraitCategories.DISADVANTAGE, TraitCategories.QUIRK],
          ),
        ),
      ],
    );
  }
}
