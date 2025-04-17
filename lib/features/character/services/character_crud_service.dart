import 'package:gurps_character_creation/features/character/models/character.dart';

abstract class CharacterCRUDService<T> {
  void add(Character character, T item);

  List<T> readAll(Character character);

  T read(Character character, String id);

  void update(Character character, T item);

  void delete(Character character, String id);
}
