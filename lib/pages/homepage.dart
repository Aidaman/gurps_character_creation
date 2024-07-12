import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 0,
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Homepage"),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
      ),
      body: Center(
        child: CustomButton(
          onPressed: () => {},
          child: const Text("Aaaaaa"),
        ),
      ),
    );
  }
}
