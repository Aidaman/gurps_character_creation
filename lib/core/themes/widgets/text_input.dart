import 'package:flutter/material.dart';

InputDecorationTheme getInputDecorationTheme(BuildContext context) =>
    InputDecorationTheme(
      labelStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
      floatingLabelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
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
