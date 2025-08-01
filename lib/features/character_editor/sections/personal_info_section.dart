// ignore_for_file: unused_field

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/character/providers/personal_info_provider.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:provider/provider.dart';

class _PersonalInfoField {
  final String label;
  final String? defaultValue;
  final String? Function(String? str) validator;
  final void Function(String? value) onChanged;

  _PersonalInfoField({
    required this.label,
    required this.defaultValue,
    required this.onChanged,
    required this.validator,
  });
}

class PersonalInfoSection extends StatelessWidget {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final PersonalInfoProvider personalInfoProvider;

  PersonalInfoSection({
    super.key,
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
        child: personalInfoProvider.personalInfo.avatarURL.isEmpty
            ? const Placeholder(
                child: Icon(
                  Icons.person_4_outlined,
                  size: 48,
                ),
              )
            : CircleAvatar(
                child: Image.file(
                  File(personalInfoProvider.getField('avatarURL')),
                ),
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
        defaultValue: field.defaultValue,
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
            defaultValue: field.defaultValue,
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
        defaultValue: field.defaultValue,
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
        defaultValue: personalInfoProvider.getField('Players Name'),
        validator: validateText,
        onChanged: (String? value) {
          personalInfoProvider.update(
            field: 'Players Name',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
      ),
      _PersonalInfoField(
        label: 'Character Name',
        defaultValue: personalInfoProvider.getField('Character Name'),
        validator: validateText,
        onChanged: (String? value) {
          personalInfoProvider.update(
            field: 'Character Name',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
      ),
      _PersonalInfoField(
        label: 'Age',
        defaultValue: personalInfoProvider.getField('Age'),
        validator: validatePositiveNumber,
        onChanged: (String? value) {
          personalInfoProvider.update(
            field: 'Age',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
      ),
      _PersonalInfoField(
        label: 'Height',
        defaultValue: personalInfoProvider.getField('Height'),
        validator: validatePositiveNumber,
        onChanged: (String? value) {
          personalInfoProvider.update(
            field: 'Height',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
      ),
      _PersonalInfoField(
        label: 'Weight',
        defaultValue: personalInfoProvider.getField('Weight'),
        validator: validatePositiveNumber,
        onChanged: (value) {
          personalInfoProvider.update(
            field: 'Weight',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
      ),
      _PersonalInfoField(
        label: 'Size Modifier',
        defaultValue: personalInfoProvider.getField('Size Modifier'),
        validator: validatePositiveNumber,
        onChanged: (value) {
          personalInfoProvider.update(
            field: 'Size Modifier',
            value: value,
          );
          context.read<AutosaveService>().triggerAutosave(context);
        },
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
              (_PersonalInfoField entry) => _buildField(
                context,
                field: entry,
              ),
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
