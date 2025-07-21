import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/features/initialization/view/splash_screen.dart';

class ErrorScreen extends StatelessWidget {
  final void Function()? _onReportBugClick;
  final void Function()? _onIgnoreErrorsClick;

  const ErrorScreen({
    super.key,
    void Function()? onReportBugClick,
    void Function()? onIgnoreErrorsClick,
  })  : _onIgnoreErrorsClick = onReportBugClick,
        _onReportBugClick = onReportBugClick;

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning,
            color: Colors.amber[800],
            size: 64,
          ),
          const Gap(24),
          Text(
            'The application couldn\'t initiate properly. You still can use it, but you are recomended to be cautious',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (_onReportBugClick != null) const Gap(12),
          if (_onReportBugClick != null)
            FilledButton(
              onPressed: _onReportBugClick,
              child: const Text('Report Bug'),
            ),
          if (_onIgnoreErrorsClick != null) const Gap(12),
          if (_onIgnoreErrorsClick != null)
            TextButton(
              onPressed: _onIgnoreErrorsClick,
              child: const Text('Use anyway'),
            ),
        ],
      ),
    );
  }
}
