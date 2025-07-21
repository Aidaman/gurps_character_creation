import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  final Widget _child;
  const SplashScreen({super.key, required Widget child}) : _child = child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        child: Center(
          child: _child,
        ),
      ),
    );
  }
}
