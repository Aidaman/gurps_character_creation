import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();
  Character get character => _character;
  set character(Character value) {
    _character = value;

    notifyListeners();
  }

  bool _isDirty = false;
  bool get isDirty => _isDirty;

  void clearProgress() {
    _character = Character.empty();
    _isDirty = false;
    notifyListeners();
  }

  void updateCharacterMaxPoints(int? newValue) {
    _character.points = newValue ?? _character.points;
    notifyListeners();
  }

  void markDirty() {
    _isDirty = true;
    notifyListeners();
  }

  void loadCharacterFromJson(Map<String, dynamic> jsonData) {
    _character = Character.fromJson(jsonData);

    notifyListeners();
  }
}
