import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/providers/character_provider.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:provider/provider.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

// TODO: Define what can be placed on this page as well aside points only. Consult with tester(s). POssibly scrap the idea all together
class _SetupPageState extends State<SetupPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
                context,
                routes
                    .singleWhere(
                      (element) => element.name.toLowerCase() == 'settings',
                    )
                    .destination,
              );
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
          child: Container(
            width: MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
                ? SETUP_PAGE_FORM_DESKTOP_WIDTH
                : SETUP_PAGE_FORM_MOBILE_WIDTH,
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Theme.of(context).colorScheme.shadow,
                  spreadRadius: 1,
                  offset: const Offset(2, 8),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Presetup',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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

                    characterProvider.updateCharacterField(
                      'points',
                      value,
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
                        routes
                            .singleWhere(
                              (element) =>
                                  element.name.toLowerCase() == 'compose',
                            )
                            .destination,
                      );
                    }
                  },
                  child: const Text('continue'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
