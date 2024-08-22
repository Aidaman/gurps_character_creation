import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String) onChanged;
  final String fieldName;
  final TextEditingController textEditingController;

  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.fieldName,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        label: Text(
          fieldName,
          style: const TextStyle(
            fontSize: 12,
          ),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
