import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  final IconData iconValue;
  final void Function() onPressed;
  final String label;
  final Color? backgroundColor;

  const LabeledIconButton({
    super.key,
    required this.iconValue,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            iconValue,
          ),
          style: IconButton.styleFrom(backgroundColor: backgroundColor),
          onPressed: onPressed,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        )
      ],
    );
  }
}
