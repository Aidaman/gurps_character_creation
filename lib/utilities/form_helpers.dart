import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  if (keyboardType == null) {
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
