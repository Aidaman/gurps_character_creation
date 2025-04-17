import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/common_constants.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/core/utilities/form_helpers.dart';
import 'package:gurps_character_creation/providers/global/theme_provider.dart';
import 'package:gurps_character_creation/widgets/settings_card.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SettingsCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildFormDropdownMenu<ThemeMode>(
                items: List<DropdownMenuItem<ThemeMode>>.from(
                  ThemeMode.values.map(
                    (ThemeMode theme) => DropdownMenuItem<ThemeMode>(
                      value: theme,
                      child: Text(
                        theme.name,
                      ),
                    ),
                  ),
                ),
                initialValue: ThemeMode.system,
                onChanged: (ThemeMode? value) =>
                    themeProvider.currentTheme = value,
                context: context,
                hint: 'Theme',
              ),
              const Gap(64),
              TextButton(
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
