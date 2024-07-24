import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  final IconData iconValue;
  final void Function() onPressed;
  final String label;

  const LabeledIconButton({
    super.key,
    required this.iconValue,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(
            iconValue,
            size: 24,
          ),
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
