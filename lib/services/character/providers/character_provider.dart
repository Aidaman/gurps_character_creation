import 'package:flutter/material.dart';
import 'package:gurps_character_creation/models/character/character.dart';
import 'package:gurps_character_creation/models/gear/armor.dart';
import 'package:gurps_character_creation/models/gear/posession.dart';

class CharacterProvider with ChangeNotifier {
  Character _character = Character.empty();

  Character get character => _character;

  bool _isDirty = false;
  bool get isDirty => _isDirty;

  void clearProgress() {
    _character = Character.empty();
    _isDirty = false;
  }

  void updateCharacterMaxPoints(int? newValue) {
    _character.points = newValue ?? _character.points;
    notifyListeners();
  }

  void addPossession(Posession poss) {
    _character.possessions.add(poss);

    _isDirty = true;
    notifyListeners();
  }

  void updatePossession(Posession newPossession) {
    _character.possessions = _character.possessions
        .map(
          (Posession poss) =>
              poss.id == newPossession.id ? newPossession : poss,
        )
        .toList();

    _isDirty = true;
    notifyListeners();
  }

  void removePossession(Posession possessonToRemove) {
    _character.possessions.removeWhere(
      (Posession poss) => poss.id == possessonToRemove.id,
    );

    _isDirty = true;
    notifyListeners();
  }

  void setProfilePicture(String path) {
    _character.personalInfo.avatarURL = path;

    _isDirty = true;
    notifyListeners();
  }

  void markDirty() {
    _isDirty = true;
  }

  void loadCharacterFromJson(Map<String, dynamic> jsonData) {
    _character = Character.fromJson(jsonData);

    notifyListeners();
  }
}
