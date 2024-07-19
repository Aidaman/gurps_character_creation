import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/skills/skill.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/compose_page_layout.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_grid.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';
import 'package:gurps_character_creation/widgets/skills/skill_view.dart';
import 'package:gurps_character_creation/widgets/traits/trait_view.dart';

class ComposePage extends StatelessWidget {
  const ComposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 1,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Compose'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
      ),
      body: ComposePageLayout(
        sidebarContent: FutureBuilder<List<Trait>>(
          future: loadTraits(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // final List<Skill> skills = snapshot.data!;
            final List<Trait> traits = snapshot.data!;
            return ListView.builder(
              itemCount: traits.length,
              itemBuilder: (context, index) => TraitView(trait: traits[index]),
            );
          },
        ),
        bodyContent: const Placeholder(),
      ),

      // body: ResponsiveGrid(
      //   children: [
      //     const Center(
      //       child: Text('placeholder'),
      //     ),
      //     FutureBuilder<List<Skill>>(
      //       future: loadSkills(),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasError) {
      //           return Center(child: Text('Error: ${snapshot.error}'));
      //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //           return const Center(child: Text('No data found.'));
      //         } else if (snapshot.connectionState == ConnectionState.waiting) {
      //           return const CircularProgressIndicator();
      //         }

      //         final List<Skill> skills = snapshot.data!;
      //         return ListView.builder(
      //           itemBuilder: (context, index) =>
      //               SkillView(skill: skills[index]),
      //         );
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
