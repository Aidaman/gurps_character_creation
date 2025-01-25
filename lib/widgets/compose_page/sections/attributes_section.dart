import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/compose_page/attribute_view.dart';
import 'package:provider/provider.dart';

class AttributesSection extends StatelessWidget {
  const AttributesSection({super.key});

  Widget _primaryAttributesView(Attributes attribute, BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final int primaryAttributeValue =
        characterProvider.character.attributes.getAttribute(attribute);

    return AttributeView(
      attribute: attribute,
      stat: primaryAttributeValue,
      pointsSpent:
          characterProvider.character.attributes.getPointsInvestedIn(attribute),
      onIncrement: () {
        characterProvider.updateCharacterField(
          attribute.stringValue,
          attribute.adjustPriceOf.toString(),
        );
      },
      onDecrement: () {
        characterProvider.updateCharacterField(
          attribute.stringValue,
          (attribute.adjustPriceOf * -1).toString(),
        );
      },
    );
  }

  Widget _derivedAttributesView(Attributes attribute, BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final int derivedAttributesValue =
        characterProvider.character.attributes.getAttribute(attribute);

    return AttributeView(
      attribute: attribute,
      stat: derivedAttributesValue,
      pointsSpent:
          characterProvider.character.attributes.getPointsInvestedIn(attribute),
      onIncrement: () {
        characterProvider.updateCharacterField(
          attribute.stringValue,
          (attribute.adjustPriceOf).toString(),
        );
      },
      onDecrement: () {
        characterProvider.updateCharacterField(
          attribute.stringValue,
          (attribute.adjustPriceOf * -1).toString(),
        );
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
