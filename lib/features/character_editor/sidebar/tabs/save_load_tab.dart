import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/services/notification_service.dart';
import 'package:gurps_character_creation/core/services/service_locator.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:gurps_character_creation/features/character_editor/services/autosave_service.dart';
import 'package:gurps_character_creation/features/character_registry/providers/character_registry_provider.dart';

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
              serviceLocator.get<AutosaveService>().cancelAutosave();
              try {
                await CharacterIOService.saveCharacter();

                final Character character =
                    serviceLocator.get<CharacterProvider>().character;

                serviceLocator
                    .get<CharacterRegistryProvider>()
                    .updateOne(character);

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
            onPressed: () async => await CharacterIOService.saveCharacterAs(),
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
            onPressed: () async => await CharacterIOService.loadCharacterFrom(),
          ),
        ],
      ),
    );
  }
}
