import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';

class AutosaveService {
  final CharacterIOService _ioService;

  static const Duration _defaultDelay = Duration(seconds: 5);
  final Duration? _delay;
  Timer? _debounce;

  AutosaveService(CharacterIOService ioService, Duration? delay)
      : _ioService = ioService,
        _delay = delay;

  void triggerAutosave(BuildContext context) {
    _debounce?.cancel();
    _debounce = Timer(
      _delay ?? _defaultDelay,
      () async {
        await _ioService.saveCharacter(context);
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
