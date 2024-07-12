import 'package:flutter/material.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      body: Center(
        child: CustomButton(
          onPressed: () => {},
          child: const Text("Bbbbbb"),
        ),
      ),
    );
  }
}
