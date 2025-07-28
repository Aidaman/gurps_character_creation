import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/features/character/models/character.dart';
import 'package:gurps_character_creation/features/character/models/personal_info.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:provider/provider.dart';

class CharacterListView extends StatelessWidget {
  final Character _character;

  const CharacterListView({super.key, required Character character})
      : _character = character;

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

  void _onEditPressed(BuildContext context) {
    context.read<CharacterProvider>().character = _character;
    Navigator.of(context).pushNamed(AppRoutes.COMPOSE.destination);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH) {
          return;
        }

        _onEditPressed(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
        child: Row(
          children: [
            Column(
              children: [
                if (_character.personalInfo.avatarURL.isEmpty)
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    child: Text(_getEmptyAvatar(_character.personalInfo)),
                  ),
                if (_character.personalInfo.avatarURL.isNotEmpty)
                  CircleAvatar(
                    foregroundImage: FileImage(
                      File(_character.personalInfo.avatarURL),
                    ),
                  )
              ],
            ),
            const Gap(16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _character.personalInfo.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    '${_character.remainingPoints}/${_character.points} points',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Gap(16),
            IconButton(
              onPressed: () => _onEditPressed(context),
              icon: const Icon(Icons.edit),
            ),
            const Gap(8),
            IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
          ],
        ),
      ),
    );
  }
}
