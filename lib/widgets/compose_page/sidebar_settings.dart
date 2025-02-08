import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/models/aspects/attributes.dart';
import 'package:gurps_character_creation/models/aspects/skills/skill.dart';
import 'package:gurps_character_creation/models/aspects/spells/spell.dart';
import 'package:gurps_character_creation/models/aspects/traits/trait.dart';
import 'package:gurps_character_creation/providers/character/character_provider.dart';
import 'package:gurps_character_creation/providers/theme_provider.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/form_helpers.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:provider/provider.dart';

class SidebarSettingsTab extends StatelessWidget {
  const SidebarSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final CharacterProvider characterProvider =
        Provider.of<CharacterProvider>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theme',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          buildFormDropdownMenu<ThemeMode>(
            items: List<DropdownMenuItem<ThemeMode>>.from(
              ThemeMode.values.map(
                (ThemeMode theme) => DropdownMenuItem<ThemeMode>(
                  value: theme,
                  child: Text(
                    theme.name == 'system'
                        ? 'System Default'
                        : '${theme.name[0].toUpperCase()}${theme.name.substring(1)} Mode',
                  ),
                ),
              ),
            ),
            initialValue: ThemeMode.system,
            onChanged: (ThemeMode? value) => themeProvider.currentTheme = value,
            context: context,
            hint: 'Theme',
          ),
          const Gap(24),
          Text(
            'Points',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          buildTextFormField(
            context: context,
            label: 'Max Points',
            validator: validateNumber,
            defaultValue: characterProvider.character.points.toString(),
            onChanged: (String? value) {
              if (value == null) {
                return;
              }

              characterProvider.updateCharacterMaxPoints(
                parseInput(value, int.parse),
              );
            },
          ),
          const Gap(32),
          const Divider(),
          Center(
            child: TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                    applicationName: 'GURPS\nComposer',
                    applicationVersion: '0.0.1',
                    applicationIcon: SvgPicture.asset(
                      'assets/spell_book.svg',
                      height:
                          MediaQuery.of(context).size.width > MAX_MOBILE_WIDTH
                              ? LOGO_ICON_SIZE_ABOUT_DIALOG_DESKTOP
                              : LOGO_ICON_SIZE_ABOUT_DIALOG_MOBILE,
                    ),
                  ),
                );
              },
              child: const Text('About this application'),
            ),
          )
        ],
      ),
    );
  }
}
