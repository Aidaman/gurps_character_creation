import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/core/services/service_locator.dart';
import 'package:gurps_character_creation/core/utilities/dialog_shape.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:gurps_character_creation/features/character_editor/widgets/empty_category_action.dart';
import 'package:gurps_character_creation/features/traits/models/trait.dart';
import 'package:gurps_character_creation/features/traits/models/trait_categories.dart';
import 'package:gurps_character_creation/features/traits/providers/traits_provider.dart';
import 'package:gurps_character_creation/features/character_editor/dialogs/select_trait_modifiers.dart';
import 'package:gurps_character_creation/features/traits/widgets/trait_view.dart';

class TraitsSection extends StatelessWidget {
  final TraitsProvider _traitsProvider;

  const TraitsSection({
    super.key,
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
      return EmptyCategoryAction(
        categories: List.from(
          categories.map(
            (TraitCategories tc) => tc.stringValue,
          ),
        ),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.from(traits.map(
        (Trait t) => TraitView(
          trait: t,
          onRemoveClick: () {
            _traitsProvider.delete(t);
            serviceLocator.get<AutosaveService>().triggerAutosave();
          },
          onChangeModifiersClick: _generateChangeModifiers(context, t),
          onChangePlaceholderClick: () async {
            await _traitsProvider.updateTraitTitle(t, context);
            serviceLocator.get<AutosaveService>().triggerAutosave();
          },
          onIncreaseLevel: t.canLevel
              ? () {
                  _traitsProvider.updateTraitLevel(t, doIncrease: true);
                  serviceLocator.get<AutosaveService>().triggerAutosave();
                }
              : null,
          onReduceLevel: t.canLevel
              ? () {
                  _traitsProvider.updateTraitLevel(t, doIncrease: false);
                  serviceLocator.get<AutosaveService>().triggerAutosave();
                }
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
