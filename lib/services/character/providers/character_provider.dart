import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();

  Character get character => _character;

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

  void setProfilePicture(String path) {
    _character.personalInfo.avatarURL = path;

    _isDirty = true;
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
