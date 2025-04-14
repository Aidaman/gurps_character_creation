import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/services/character/character_io_service.dart';

class SidebarSaveLoadTab extends StatelessWidget {
  final CharacterIOService characterIOService;
  const SidebarSaveLoadTab({super.key, required this.characterIOService});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Save',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(4),
          FilledButton.icon(
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Character'),
            onPressed: () async =>
                await characterIOService.saveCharacter(context),
          ),
          const Gap(8),
          FilledButton.icon(
            icon: const Icon(Icons.save_as_outlined),
            label: const Text('Save Character As'),
            onPressed: () async =>
                await characterIOService.saveCharacterAs(context),
          ),
          const Gap(24),
          Text(
            'Load',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Gap(8),
          FilledButton.icon(
            icon: const Icon(Icons.save_alt_outlined),
            label: const Text('Load Character'),
            onPressed: () async =>
                await characterIOService.loadCharacter(context),
          ),
        ],
      ),
    );
  }
}
