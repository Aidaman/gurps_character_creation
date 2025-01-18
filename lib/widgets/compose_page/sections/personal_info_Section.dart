import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:provider/provider.dart';

class _BasicInfoField {
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _BasicInfoField({
    required this.controller,
    required this.keyboardType,
  });
}

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({super.key});

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final List<Map<String, _BasicInfoField>> _basicInfoControllers = [
    {
      'Players Name': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.name,
      ),
      'Character Name': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.name,
      ),
    },
    {
      'Age': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      ),
      'Height': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      ),
    },
    {
      'Weight': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      ),
      'Size Modifier': _BasicInfoField(
        controller: TextEditingController(),
        keyboardType: TextInputType.number,
      ),
    },
  ];

  Widget _generateSingleInput(
    MapEntry<String, _BasicInfoField> entry,
    CharacterProvider characterProvider,
  ) {
    Widget textField = TextField(
      controller: entry.value.controller,
      onChanged: (String value) => characterProvider.updateCharacterField(
        entry.key,
        value,
      ),
      keyboardType: entry.value.keyboardType,
      inputFormatters: addTextInputFormatters(
        entry.value.keyboardType,
        true,
      ),
      decoration: InputDecoration(
        label: Text(
          entry.key,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );

    final double spacing = MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
        ? DESKTOP_COLUMNS_SPACING
        : MOBILE_ROWS_SPACING;

    return Padding(
      padding: EdgeInsets.only(bottom: spacing, left: 8, right: 8),
      child: textField,
    );
  }

  // For now it only serves a rather decorative function, later on it will be able to pick an image
  Container _buildCharacterAvatar() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 128,
        maxWidth: 128,
        minHeight: 86,
        minWidth: 86,
      ),
      child: const Placeholder(
        child: Icon(
          Icons.person_4_outlined,
          size: 48,
        ),
      ),
    );
  }

  Widget _visualiseFields(Map<String, _BasicInfoField> map) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    final bool isSingleElement = map.entries.length == 1;

    if (isSingleElement) {
      return _generateSingleInput(map.entries.first, characterProvider);
    }

    final Widget body = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.from(map.entries.map(
        (MapEntry<String, _BasicInfoField> e) => _generateSingleInput(
          e,
          characterProvider,
        ),
      )),
    );

    if (isMobile) {
      return body;
    }

    return Expanded(child: body);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final double spacing =
        isMobile ? DESKTOP_COLUMNS_SPACING : MOBILE_ROWS_SPACING;

    final List<Widget> children = [
      _buildCharacterAvatar(),
      Gap(spacing),
      ..._basicInfoControllers.map(_visualiseFields),
    ];

    if (isMobile) {
      return Column(children: children);
    }

    return Row(children: children);
  }

  @override
  void dispose() {
    for (var entry in _basicInfoControllers) {
      for (var e in entry.entries) {
        e.value.controller.dispose();
      }
    }

    super.dispose();
  }
}
