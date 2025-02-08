import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/providers/character/personal_info_provider.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class _PersonalInfoField {
  final String label;
  final String? Function(String? str) validator;
  final void Function(String? value) onChanged;

  _PersonalInfoField({
    required this.label,
    required this.onChanged,
    required this.validator,
  });
}

class PersonalInfoSection extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final Character character;
  final PersonalInfoProvider personalInfoProvider;

  PersonalInfoSection({
    super.key,
    required this.character,
    required this.personalInfoProvider,
  });

  Widget _buildCharacterAvatar() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles();

        if (result == null) {
          return;
        }

        personalInfoProvider.update(
          field: 'avatarURL',
          value: result.files.first.path!,
        );
      },
      child: Container(
        constraints: const BoxConstraints(
          maxHeight: 128,
          maxWidth: 128,
          minHeight: 86,
          minWidth: 86,
        ),
        child: character.personalInfo.avatarURL.isEmpty
            ? const Placeholder(
                child: Icon(
                  Icons.person_4_outlined,
                  size: 48,
                ),
              )
            : Image.file(
                File(character.personalInfo.avatarURL),
              ),
      ),
    );
  }

  Widget _buildField(
    BuildContext context, {
    required _PersonalInfoField field,
    BoxConstraints? constraints,
  }) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    if (isMobile) {
      return buildTextFormField(
        label: field.label,
        validator: field.validator,
        onChanged: field.onChanged,
        context: context,
      );
    }
    const double HORIZONTAL_SPACING = 8;

    if (isMobile || constraints == null) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: MOBILE_ROWS_SPACING,
            left: HORIZONTAL_SPACING,
            right: HORIZONTAL_SPACING,
          ),
          child: buildTextFormField(
            label: field.label,
            validator: field.validator,
            onChanged: field.onChanged,
            context: context,
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxWidth: constraints.maxWidth / 3 - (HORIZONTAL_SPACING * 2),
      ),
      padding: const EdgeInsets.only(
        left: HORIZONTAL_SPACING,
        right: HORIZONTAL_SPACING,
      ),
      child: buildTextFormField(
        label: field.label,
        validator: field.validator,
        onChanged: field.onChanged,
        context: context,
      ),
    );
  }

  Widget _buildDesktopBody(List<_PersonalInfoField> personalInfoFields) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            alignment: WrapAlignment.start,
            runSpacing: 0,
            children: personalInfoFields
                .map(
                  (_PersonalInfoField entry) => _buildField(
                    context,
                    field: entry,
                    constraints: constraints,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<_PersonalInfoField> personalInfoFields = [
      _PersonalInfoField(
        label: 'Players Name',
        validator: validateText,
        onChanged: (String? value) => personalInfoProvider.update(
          field: 'Players Name',
          value: value,
        ),
      ),
      _PersonalInfoField(
        label: 'Character Name',
        validator: validateText,
        onChanged: (String? value) => personalInfoProvider.update(
          field: 'Character Name',
          value: value,
        ),
      ),
      _PersonalInfoField(
        label: 'Age',
        validator: validatePositiveNumber,
        onChanged: (String? value) => personalInfoProvider.update(
          field: 'Age',
          value: value,
        ),
      ),
      _PersonalInfoField(
        label: 'Height',
        validator: validatePositiveNumber,
        onChanged: (String? value) => personalInfoProvider.update(
          field: 'Height',
          value: value,
        ),
      ),
      _PersonalInfoField(
        label: 'Weight',
        validator: validatePositiveNumber,
        onChanged: (value) => personalInfoProvider.update(
          field: 'Weight',
          value: value,
        ),
      ),
      _PersonalInfoField(
        label: 'Size Modifier',
        validator: validatePositiveNumber,
        onChanged: (value) => personalInfoProvider.update(
          field: 'Size Modifier',
          value: value,
        ),
      ),
    ];

    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;
    final double spacing =
        isMobile ? MOBILE_ROWS_SPACING : DESKTOP_COLUMNS_SPACING;

    final List<Widget> base = [
      _buildCharacterAvatar(),
      Gap(spacing),
    ];

    if (isMobile) {
      return Form(
        child: Column(
          children: [
            ...base,
            ...personalInfoFields.map(
              (_PersonalInfoField entry) => _buildField(context, field: entry),
            ),
            Gap(spacing),
          ],
        ),
      );
    }

    return Form(
      child: Row(
        children: [
          ...base,
          _buildDesktopBody(personalInfoFields),
        ],
      ),
    );
  }
}
