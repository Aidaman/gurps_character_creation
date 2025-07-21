import 'package:flutter/material.dart';

CardTheme getCardTheme(BuildContext context) => CardTheme(
      surfaceTintColor: Theme.of(context).colorScheme.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 2.0,
    );
