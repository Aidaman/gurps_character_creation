import 'package:flutter/material.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      body: Center(
        child: CustomButton(
          onPressed: () => {},
          child: const Text("Aaaaaa"),
        ),
      ),
    );
  }
}
