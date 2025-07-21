import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';

class SettingsCard extends StatelessWidget {
  final Widget child;

  const SettingsCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation:
          MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH ? null : 0,
      child: Container(
        width: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
            ? SETTING_CARD_DESKTOP_WIDTH
            : null,
        height: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
            ? null
            : MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: child,
      ),
    );
  }
}
