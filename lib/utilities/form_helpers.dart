import 'package:flutter/material.dart';

enum FormEntryTypes {
  TEXT_FIELD,
  DROPDOWN_MENU,
}

class FormEntry<T> {
  final TextEditingController? controller;
  final FormEntryTypes type;
  final String label;
  final List<T>? dropdownMenuEntries;
  final void Function(String value)? onChanged;
  final void Function(T? value)? onSelected;

  FormEntry({
    this.controller,
    required this.type,
    required this.label,
    this.dropdownMenuEntries,
    this.onChanged,
    this.onSelected,
  });
}
