import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/widgets/settings_card.dart';
import 'package:provider/provider.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildWarningPrompt(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

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
                  characterProvider.clearProgress();

                  Navigator.popAndPushNamed(
                      context, AppRoutes.SETUP.destination);
                },
                child: const Text('proceed'),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.popAndPushNamed(
                  context,
                  AppRoutes.COMPOSE.destination,
                ),
                child: const Text('save & continue'),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildNewCharacterPrompt(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Presetup',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Gap(32),
        buildTextFormField(
          context: context,
          label: 'Max Points',
          validator: validateNumber,
          allowsDecimal: false,
          defaultValue: '',
          keyboardType: TextInputType.number,
          onChanged: (String? value) {
            if (value == null) {
              return;
            }

            characterProvider.updateCharacterMaxPoints(
              parseInput(value, int.parse),
            );
          },
        ),
        Text(
          'Define amount of points you can invest in your character',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(32),
        TextButton(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Navigator.popAndPushNamed(
                context,
                AppRoutes.COMPOSE.destination,
              );
            }
          },
          child: const Text('continue'),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: APP_BAR_HEIGHT,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(
                  context, AppRoutes.SETTINGS.destination);
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          )
        ],
      ),
      body: Form(
        key: _formkey,
        child: Center(
          child: SettingsCard(
            child: characterProvider.isDirty
                ? _buildWarningPrompt(context)
                : _buildNewCharacterPrompt(context),
          ),
        ),
      ),
    );
  }
}
