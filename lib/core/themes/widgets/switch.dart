import 'package:flutter/material.dart';

SwitchThemeData getSwitchThemeData(BuildContext context) => SwitchThemeData(
      trackOutlineWidth: WidgetStateProperty.resolveWith(
        (states) => 0,
      ),
      trackOutlineColor: WidgetStateColor.resolveWith(
        (states) => Colors.transparent,
      ),
      thumbColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).colorScheme.primary;
        }
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).colorScheme.onPrimary;
        }
        return Theme.of(context).colorScheme.onPrimary;
      }),
      trackColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Theme.of(context).colorScheme.primary.withOpacity(0.5);
        }
        if (states.contains(WidgetState.disabled)) {
          return Theme.of(context).colorScheme.onPrimary.withOpacity(0.5);
        }
        return Theme.of(context).colorScheme.secondary;
      }),
      thumbIcon: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Icon(Icons.check);
        }
        if (states.contains(WidgetState.disabled)) {
          return const Icon(Icons.close);
        }
        return Icon(
          Icons.close,
          color: Theme.of(context).colorScheme.primary,
        );
      }),
    );
