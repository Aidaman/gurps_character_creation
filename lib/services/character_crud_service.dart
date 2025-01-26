import 'package:gurps_character_creation/models/character/character.dart';

abstract class CharacterGearCRUDService<T> {
  void create(Character character, T item);

  List<T> readAll(Character character);

  T read(Character character, String id);

  void update(Character character, T item);

  void delete(Character character, String id);
}
