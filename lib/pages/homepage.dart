import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/spell_book.svg',
              height: MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH
                  ? 128
                  : 200,
            ),
            Text(
              'Welcome to GURPS Composer',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  routes
                      .singleWhere(
                        (element) => element.name.toLowerCase() == 'setup',
                      )
                      .destination,
                );
              },
              child: const Text('Click here to Compose a Character Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
