import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final List<Widget> tabs;
  final List<IconData> actions;

  const Sidebar({
    super.key,
    required this.tabs,
    required this.actions,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tabs.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            dividerColor: Theme.of(context).colorScheme.secondary,
            tabAlignment: TabAlignment.start,
            tabs: widget.actions
                .map(
                  (IconData e) => Tab(
                    icon: Icon(e),
                    height: 32,
                  ),
                )
                .toList(),
          ),
          Expanded(
            child: TabBarView(
              children: widget.tabs,
            ),
          ),
        ],
      ),
    );
  }
}
