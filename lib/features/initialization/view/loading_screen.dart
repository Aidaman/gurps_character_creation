import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/features/initialization/view/splash_screen.dart';

class LoadingScreen extends StatelessWidget {
  final String _loadingMessage;
  const LoadingScreen({super.key, required String loadingMessage})
      : _loadingMessage = loadingMessage;

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const Gap(24),
          Text(
            _loadingMessage,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
