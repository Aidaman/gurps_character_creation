import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/common_constants.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:gurps_character_creation/features/character/services/character_io_service.dart';
import 'package:gurps_character_creation/features/character_setup/prompts/warning_prompt.dart';
import 'package:gurps_character_creation/widgets/settings_card.dart';
import 'package:provider/provider.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  Widget _buildNewCharacterPrompt(BuildContext context) {
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

            context
                .read<CharacterProvider>()
                .updateCharacterMaxPoints(parseInput(value, int.parse));
          },
        ),
        Text(
          'Define amount of points you can invest in your character',
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const Gap(8),
        TextButton.icon(
          onPressed: () {
            if (_formkey.currentState!.validate()) {
              Navigator.popAndPushNamed(
                context,
                AppRoutes.COMPOSE.destination,
              );
            }
          },
          iconAlignment: IconAlignment.end,
          icon: const Icon(Icons.arrow_forward),
          label: const Text('continue'),
        ),
        const Gap(32),
        TextButton.icon(
          onPressed: () async {
            if (await CharacterIOService.loadCharacterFrom()) {
              Navigator.popAndPushNamed(context, AppRoutes.COMPOSE.destination);
            }
          },
          label: Text(
            'Load existing character',
            style: Theme.of(context).textTheme.labelSmall,
          ),
          icon: const Icon(Icons.upload_file_outlined),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingCard = SettingsCard(
      child: context.watch<CharacterProvider>().isDirty
          ? const WarningPrompt()
          : _buildNewCharacterPrompt(context),
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: APP_BAR_HEIGHT,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.SETTINGS.destination);
            },
            icon: const Icon(
              Icons.settings_outlined,
            ),
          )
        ],
      ),
      body: Form(
        key: _formkey,
        child: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
            ? Center(child: settingCard)
            : SettingsCard(child: settingCard),
      ),
    );
  }
}
