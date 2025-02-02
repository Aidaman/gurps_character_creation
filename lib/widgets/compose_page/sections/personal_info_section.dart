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

  Widget _buildFields(Set<_PersonalInfoField> fields, BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;

    final double spacing = MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
        ? DESKTOP_COLUMNS_SPACING
        : MOBILE_ROWS_SPACING;
    final bool isSingleElement = fields.length == 1;

    if (isSingleElement) {
      Widget child = buildTextFormField(
        label: fields.first.label,
        validator: fields.first.validator,
        onChanged: fields.first.onChanged,
        context: context,
      );

      if (isMobile) {
        return child;
      }

      return Expanded(
        child: Padding(
          padding: EdgeInsets.only(bottom: spacing, left: 8, right: 8),
          child: child,
        ),
      );
    }

    List<Widget> children = fields
        .map(
          (_PersonalInfoField field) => buildTextFormField(
            label: field.label,
            validator: field.validator,
            onChanged: field.onChanged,
            context: context,
          ),
        )
        .toList();

    if (isMobile) {
      return Column(children: children);
    }

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: spacing, left: 8, right: 8),
        child: Column(children: children),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Set<_PersonalInfoField>> basicInfoControllers = [
      {
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
      },
      {
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
      },
      {
        _PersonalInfoField(
          label: 'Weight',
          validator: validatePositiveNumber,
          onChanged: (value) => personalInfoProvider.update(
            field: 'Weight',
            value: value,
          ),
        ),
      },
    ];

    final bool isMobile = MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH;
    final double spacing =
        isMobile ? MOBILE_ROWS_SPACING : DESKTOP_COLUMNS_SPACING;

    final List<Widget> body = [
      _buildCharacterAvatar(),
      Gap(spacing),
      ...basicInfoControllers.map(
        (Set<_PersonalInfoField> entry) => _buildFields(entry, context),
      ),
      if (isMobile) Gap(spacing),
    ];

    if (isMobile) {
      return Form(
        child: Column(children: body),
      );
    }

    return Form(
      child: Row(children: body),
    );
  }
}
