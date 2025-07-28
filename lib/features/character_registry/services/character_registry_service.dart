import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character_registry/providers/character_registry_provider.dart';

class CharacterRegistryService {
  final CharacterRegistryProvider _characterRegistryProvider;
  List<Character> get _characters => _characterRegistryProvider.characters;

  CharacterRegistryService(CharacterRegistryProvider characterRegistryProvider)
      : _characterRegistryProvider = characterRegistryProvider;

  List<Character> readAll() => _characters;

  Character readById(String id) => _characters.firstWhere((x) => x.id == id);

  void addOne(Character newCharacter) => _characters.add(newCharacter);

  void updateOne(Character newCharacter) =>
      _characterRegistryProvider.characters = _characters
          .map((x) => x.id == newCharacter.id ? newCharacter : x)
          .toList();

  void deleteOne(String id) {
    _characterRegistryProvider.characters =
        _characters.where((x) => x.id != id).toList();
  }
}
