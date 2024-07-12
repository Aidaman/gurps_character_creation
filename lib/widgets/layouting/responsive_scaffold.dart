import 'package:flutter/material.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

class ResponsiveScaffold extends StatelessWidget {
  final Widget body;

  const ResponsiveScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red[900],
      ),
      body: body,
      drawer: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth <= MAX_MOBILE_WIDTH) {
            return Container();
          }

          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('Menu'),
                ),
                ListTile(
                  title: const Text('Item 1'),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('Item 2'),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > MAX_MOBILE_WIDTH) {
            return Container();
          }

          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.business),
                label: 'Business',
              ),
            ],
            selectedItemColor: Colors.amber[800],
          );
        },
      ),
    );
  }
}
