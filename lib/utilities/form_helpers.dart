import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';

RegExp placeholderAspectRegex = RegExp(r'@([^@]+)@');

String? validateDropdown<T>(T value) {
  if (value == null || value.toString().isEmpty) {
    return 'please select a value';
  }

  return null;
}

String? validateText(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter some text';
  }

  return null;
}

String? validatePositiveNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter some positive number';
  }

  return null;
}

String? validateNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'please enter some number';
  }

  return null;
}

String? validateWoleNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter some whole number';
  }

  return null;
}

List<TextInputFormatter> addTextInputFormatters(
  TextInputType? keyboardType,
  bool? isDecimal,
) {
  if (keyboardType == null || keyboardType == TextInputType.name) {
    return [];
  }

  List<TextInputFormatter> formatters = [];

  if (isDecimal != null) {
    formatters.add(
      FilteringTextInputFormatter.allow(
        isDecimal
            ? RegExp(r'^\d+\.?\d{0,2}') // Allows decimals with up to 2 places
            : RegExp(r'^\d+'), // Restricts to integers only
      ),
    );
  }

  return formatters;
}

T? parseInput<T>(String value, T Function(String value) parser) {
  try {
    return parser(value);
  } catch (e) {
    return null;
  }
}

Widget markAsGroup({
  required Widget child,
  required String title,
  required BuildContext context,
  String? description,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.fromBorderSide(
        BorderSide(color: Theme.of(context).colorScheme.primary),
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.only(
      bottom: 16.0,
      left: 8,
      right: 8,
    ),
    child: Column(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        child,
        const Gap(16),
        if (description != null)
          Text(
            description,
            style: Theme.of(context).textTheme.labelSmall,
          )
      ],
    ),
  );
}

Widget buildFormDropdownMenu<T>({
  required List<DropdownMenuItem<T>> items,
  required void Function(T? value) onChanged,
  required BuildContext context,
  required String hint,
  T? initialValue,
}) {
  return DropdownButtonFormField<T>(
    style: Theme.of(context).textTheme.bodyMedium,
    borderRadius: BorderRadius.circular(8),
    hint: Text(
      hint,
      style: Theme.of(context).textTheme.labelMedium,
    ),
    decoration: InputDecoration(
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    validator: validateDropdown,
    items: items,
    onChanged: onChanged,
    value: initialValue,
  );
}

Widget buildTextFormField({
  required String label,
  required String? Function(String? str) validator,
  required void Function(String? value) onChanged,
  required BuildContext context,
  String? defaultValue,
  TextInputType? keyboardType,
  int? maxLines = 1,
  bool? allowsDecimal,
}) {
  return TextFormField(
    maxLines: maxLines,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    keyboardType: keyboardType ?? TextInputType.text,
    inputFormatters: addTextInputFormatters(keyboardType, allowsDecimal),
    decoration: InputDecoration(
      labelText: label,
      labelStyle: Theme.of(context).textTheme.labelMedium,
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
    ),
    initialValue: defaultValue,
    onChanged: onChanged,
    validator: validator,
  );
}
