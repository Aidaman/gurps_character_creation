import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
          ? SETTING_CARD_DESKTOP_WIDTH
          : SETTING_CARD_MOBILE_WIDTH,
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Theme.of(context).colorScheme.shadow,
            spreadRadius: 1,
            offset: const Offset(2, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
