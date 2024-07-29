import 'package:flutter/material.dart';

class ExpandedTextField extends StatelessWidget {
  final void Function(String) onChanged;
  final String fieldName;
  final TextEditingController textEditingController;

  const ExpandedTextField({
    super.key,
    required this.onChanged,
    required this.fieldName,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: textEditingController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          label: Text(fieldName),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
