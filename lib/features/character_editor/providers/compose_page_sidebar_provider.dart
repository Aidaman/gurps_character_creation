import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';

class ComposePageSidebarProvider extends ChangeNotifier {
  bool _isSidebarVisible = false;
  bool get isSidebarVisible => _isSidebarVisible;

  void toggleSidebar(BuildContext context) {
    if (MediaQuery.of(context).size.width <= MIN_DESKTOP_WIDTH) {
      Scaffold.of(context).openEndDrawer();
      return;
    }

    _isSidebarVisible = !_isSidebarVisible;
    notifyListeners();
  }
}
