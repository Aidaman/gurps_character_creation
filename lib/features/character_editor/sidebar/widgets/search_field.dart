import 'dart:async';

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final void Function(String value) onSearchChanged;
  final Duration debounce;

  const SearchField({
    super.key,
    required this.onSearchChanged,
    Duration? debounceDuration,
  }) : debounce = debounceDuration ?? const Duration(milliseconds: 300);

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  Timer? _debounce;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (value) {
        if (_debounce?.isActive ?? false) _debounce?.cancel();

        _debounce = Timer(
          widget.debounce,
          () => widget.onSearchChanged(value),
        );
      },
      decoration: InputDecoration(
        labelText: 'Filter',
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
