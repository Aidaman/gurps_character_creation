import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gurps_character_creation/models/traits/trait.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/widgets/button/button.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';
import 'package:gurps_character_creation/widgets/traits/trait.dart';

class Homepage extends StatelessWidget {
  Future<List<Trait>> loadTraits() async {
    final jsonString = await rootBundle.loadString(
      'assets/Advantages/BasicSet.json',
    );
    return traitFromJson(jsonString);
  }

  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      selectedIndex: 0,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Homepage'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        toolbarHeight: APP_BAR_HEIGHT,
        elevation: COMMON_ELLEVATION,
      ),
      body: FutureBuilder<List<Trait>>(
        future: loadTraits(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          final List<Trait> traits = snapshot.data!;
          return ListView.builder(
            itemBuilder: (context, index) => TraitView(trait: traits[index]),
          );
        },
      ),
    );
  }
}
