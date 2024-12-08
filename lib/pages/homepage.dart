import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';
import 'package:gurps_character_creation/widgets/layouting/responsive_scaffold.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/spell_book.svg',
          height:
              MediaQuery.of(context).size.width <= MAX_MOBILE_WIDTH ? 128 : 200,
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
                    (element) => element.name == 'compose',
                  )
                  .destination,
            );
          },
          child: const Text('Click here to Compose a Character Sheet'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
        selectedIndex: 0,
        appBar: AppBar(),
        body: Center(child: _buildBody(context)));
  }
}
