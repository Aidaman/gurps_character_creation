import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character/models/personal_info.dart';
import 'package:gurps_character_creation/features/character/widgets/character_list_view.dart';
import 'package:gurps_character_creation/features/character_registry/providers/character_registry_provider.dart';
import 'package:provider/provider.dart';

class CharacterRegistry extends StatelessWidget {
  const CharacterRegistry({super.key});

  String _getEmptyAvatar(PersonalInfo personalInfo) {
    String result = '';
    if (personalInfo.avatarURL.isNotEmpty) {
      return result;
    }

    if (personalInfo.name.isEmpty && personalInfo.playerName.isEmpty) {
      return 'NN';
    }

    if (personalInfo.name.isNotEmpty) {
      result += personalInfo.name.split('').first;
    }

    if (personalInfo.playerName.isNotEmpty) {
      result += personalInfo.playerName.split('').first;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<CharacterRegistryProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: registry.characters.length,
        itemBuilder: (context, index) {
          Character character = registry.characters.elementAt(index);

          return CharacterListView(character: character);
        },
      ),
    );
  }
}
