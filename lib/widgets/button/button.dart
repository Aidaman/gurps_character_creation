import 'package:flutter/material.dart';
import 'package:gurps_character_creation/widgets/button/button_styles.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final ButtonStyles buttonStyle = ButtonStyles.DEFAULT;
  final void Function() onPressed;

  const CustomButton({super.key, required this.child, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: ButtonStylesGetter.getStyle(buttonStyle),
      child: child,
    );
  }
}
