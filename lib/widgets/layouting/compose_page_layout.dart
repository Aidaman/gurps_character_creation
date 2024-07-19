import 'package:flutter/material.dart';

class ComposePageLayout extends StatelessWidget {
  final FutureBuilder sidebarContent;
  final Widget bodyContent;
  const ComposePageLayout(
      {super.key, required this.sidebarContent, required this.bodyContent});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: bodyContent,
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0x64eeeeee)))),
          width: 256 + 128 + 64,
          child: sidebarContent,
        ),
      ],
    );
  }
}
