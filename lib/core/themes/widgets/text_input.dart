import 'package:flutter/material.dart';

InputDecorationTheme getInputDecorationTheme(BuildContext context) =>
    InputDecorationTheme(
      labelStyle: TextStyle(
        fontSize: Theme.of(context).textTheme.labelMedium?.fontSize,
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide.none,
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      alignLabelWithHint: true,
    );
