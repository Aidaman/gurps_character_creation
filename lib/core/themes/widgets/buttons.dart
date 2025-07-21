import 'package:flutter/material.dart';

TextButtonThemeData getTextButtonThemeData(BuildContext context) =>
    TextButtonThemeData(
      style: TextButton.styleFrom(
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
