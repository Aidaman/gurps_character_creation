import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/common_constants.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';

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
              'Welcome to GURPS Composer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.SETUP.destination);
              },
              child: const Text('Compose a Character Sheet'),
            ),
            const Gap(16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.SETUP.destination);
              },
              child: const Text('Watch characters'),
            ),
          ],
        ),
      ),
    );
  }
}
