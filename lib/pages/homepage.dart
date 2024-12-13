import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/common_constants.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/spell_book.svg',
              height: MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH
                  ? LOGO_ICON_SIZE_MOBILE
                  : LOGO_ICON_SIZE_DESKTOP,
            ),
            Text(
              AppLocalizations.of(context)!.empty_homepage_greetings,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.SETUP.destination);
              },
              child: Text(
                AppLocalizations.of(context)!.empty_homepage_button_text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
