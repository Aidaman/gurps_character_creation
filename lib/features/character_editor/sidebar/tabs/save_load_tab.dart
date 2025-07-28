import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/services/notification_service.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:provider/provider.dart';

class SidebarSaveLoadTab extends StatelessWidget {
  const SidebarSaveLoadTab({super.key});

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
            onPressed: () async {
              context.read<AutosaveService>().cancelAutosave();
              try {
                await characterIOService.saveCharacter();
                notificator
                    .showMessageWithSnackBar('Character Saved Successfull');
              } catch (e) {
                notificator
                    .showMessageWithSnackBar('Failed to save Character: $e');
              }
            },
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
            onPressed: () async => await characterIOService.loadCharacterFrom(),
          ),
        ],
      ),
    );
  }
}
