import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/character/models/attributes.dart';
import 'package:gurps_character_creation/features/character/providers/attributes_provider.dart';
import 'package:gurps_character_creation/features/character/widgets/attribute_view.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:provider/provider.dart';

class AttributesSection extends StatelessWidget {
  final AttributesProvider attributesProvider;

  const AttributesSection({super.key, required this.attributesProvider});

  Widget _primaryAttributesView(Attributes attribute, BuildContext context) {
    return AttributeView(
      attribute: attribute,
      stat: attributesProvider.getField(attribute),
      pointsSpent: attributesProvider.getPointsInvested(attribute),
      onIncrement: () {
        attributesProvider.update(
          attribute: attribute,
          value: attribute.adjustPriceOf,
        );
        context.read<AutosaveService>().triggerAutosave(context);
      },
      onDecrement: () {
        attributesProvider.update(
          attribute: attribute,
          value: (attribute.adjustPriceOf * -1),
        );
        context.read<AutosaveService>().triggerAutosave(context);
      },
    );
  }

  Widget _derivedAttributesView(Attributes attribute, BuildContext context) {
    final int derivedAttributesValue = attributesProvider.getField(attribute);

    return AttributeView(
      attribute: attribute,
      stat: derivedAttributesValue,
      pointsSpent: attributesProvider.getPointsInvested(attribute),
      onIncrement: () {
        attributesProvider.update(
          attribute: attribute,
          value: attribute.adjustPriceOf,
        );
        context.read<AutosaveService>().triggerAutosave(context);
      },
      onDecrement: () {
        attributesProvider.update(
          attribute: attribute,
          value: attribute.adjustPriceOf * -1,
        );
        context.read<AutosaveService>().triggerAutosave(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final List<Widget> primaryAttributes = List.from(
      AttributesExtension.primaryAttributes.map(
        (Attributes attribute) => _primaryAttributesView(attribute, context),
      ),
    );

    final List<Widget> derivedAttributes = List.from(
      AttributesExtension.derivedAttributes.map(
        (Attributes attribute) => _derivedAttributesView(attribute, context),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          ...primaryAttributes,
          ...derivedAttributes,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [...primaryAttributes],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [...derivedAttributes],
        ),
      ],
    );
  }
}
