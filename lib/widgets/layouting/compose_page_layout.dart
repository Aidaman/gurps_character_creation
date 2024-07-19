import 'package:flutter/material.dart';

class ComposePageLayout extends StatelessWidget {
  final Widget sidebarContent;
  final Widget bodyContent;

  final bool isSidebarVisible;

  const ComposePageLayout({
    super.key,
    required this.sidebarContent,
    required this.bodyContent,
    required this.isSidebarVisible,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: bodyContent,
          ),
        ),
        if (isSidebarVisible)
          Container(
            decoration: const BoxDecoration(
                border: Border(left: BorderSide(color: Color(0x64eeeeee)))),
            width: MediaQuery.of(context).size.width < 1250
                ? 256
                : MediaQuery.of(context).size.width * 0.32,
            child: sidebarContent,
          ),
      ],
    );
  }
}
