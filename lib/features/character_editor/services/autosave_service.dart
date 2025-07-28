import 'dart:async';

import 'package:gurps_character_creation/features/character/services/character_io_service.dart';

class AutosaveService {
  static const Duration _defaultDelay = Duration(seconds: 5);
  final Duration? _delay;
  Timer? _debounce;

  AutosaveService(Duration? delay) : _delay = delay;

  void triggerAutosave() {
    _debounce?.cancel();
    _debounce = Timer(
      _delay ?? _defaultDelay,
      () async {
        await CharacterIOService.saveCharacter();
      },
    );
  }

  void cancelAutosave() {
    _debounce?.cancel();
  }

  void dispose() {
    _debounce?.cancel();
  }
}
