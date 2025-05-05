// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:provider/provider.dart';

class WarningPrompt extends StatelessWidget {
  const WarningPrompt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Warning',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(32),
        Text(
          'It seems you have an unfinished work. Would you want start anew without saving?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('return'),
              ),
            ),
            Expanded(
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                onPressed: () {
                  context.read<CharacterProvider>().clearProgress();

                  Navigator.popAndPushNamed(
                    context,
                    AppRoutes.SETUP.destination,
                  );
                },
                child: const Text('proceed'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () async {
                  if (!await CharacterIOService().saveCharacterAs(context)) {
                    return;
                  }

                  context.read<CharacterProvider>().clearProgress();

                  Navigator.popAndPushNamed(
                    context,
                    AppRoutes.COMPOSE.destination,
                  );
                },
                child: const Text('save & continue'),
              ),
            ),
          ],
        )
      ],
    );
  }
}
