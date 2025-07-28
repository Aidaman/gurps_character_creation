import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/services/app_directory_service.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/character_registry/providers/character_registry_provider.dart';
import 'package:gurps_character_creation/features/equipment/providers/equipment_provider.dart';
import 'package:gurps_character_creation/features/initialization/models/load_queue_entry.dart';
import 'package:gurps_character_creation/features/settings/services/settings_provider.dart';
import 'package:provider/provider.dart';

class InitializationService {
  final Queue<LoadQueueEntry> _loadQueue;
  Queue<LoadQueueEntry> get loadQueue => _loadQueue;

  InitializationService(BuildContext context)
      : _loadQueue = Queue.from(
          [
            LoadQueueEntry(
              message: 'Loading settings...',
              task: context.read<SettingsProvider>().loadSettings,
            ),
            LoadQueueEntry(
              message: 'Loading aspects...',
              task: context.read<AspectsProvider>().loadCharacteristics,
            ),
            LoadQueueEntry(
              message: 'Loading equipment...',
              task: context.read<EquipmentProvider>().loadEquipment,
            ),
            LoadQueueEntry(
              message: 'Ensuring Application Directories...',
              task: AppDirectoryService().ensureDirectories,
            ),
            LoadQueueEntry(
              message: 'Loading characters...',
              task: context.read<CharacterRegistryProvider>().loadCharacters,
            )
          ],
        );

  Future<void> init(
    Future<dynamic> Function(LoadQueueEntry entry) process,
  ) async {
    try {
      for (var task in _loadQueue) {
        await process(task);
      }
    } catch (e, st) {
      debugPrint('🚨 Error during load: $e\n$st');
      rethrow;
    }
  }
}
