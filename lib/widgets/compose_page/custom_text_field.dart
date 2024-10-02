import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final void Function(String) onChanged;
  final String fieldName;
  final TextEditingController textEditingController;
  final bool? isTextArea;

  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.fieldName,
    required this.textEditingController,
    this.isTextArea,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: isTextArea == true ? null : 1,
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
