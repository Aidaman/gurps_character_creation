import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/responsive_layouting_constants.dart';

extension AdaptiveDialogShape on BuildContext {
  Future<T?> showAdaptiveDialog<T>({
    required WidgetBuilder builder,
    bool useRootNavigator = true,
    bool isScrollControlled = true,
  }) {
    final double screenWidth = MediaQuery.of(this).size.width;
    final double screenHeight = MediaQuery.of(this).size.height;

    if (MediaQuery.of(this).size.width > MAX_MOBILE_WIDTH &&
        MediaQuery.of(this).size.width < MIN_DESKTOP_WIDTH) {
      return showDialog<T>(
        context: this,
        useRootNavigator: useRootNavigator,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * 0.8,
              maxHeight: screenHeight * 0.8,
            ),
            child: builder(context),
          );
        },
      );
    }

    if (MediaQuery.of(this).size.width > MIN_DESKTOP_WIDTH) {
      return showDialog<T>(
        context: this,
        useRootNavigator: useRootNavigator,
        builder: (context) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: screenWidth * 0.5,
              maxWidth: screenWidth * 0.75,
              maxHeight: screenHeight * 0.75,
            ),
            child: builder(context),
          );
        },
      );
    }

    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      builder: (context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.95,
          ),
          child: builder(context),
        );
      },
    );
  }
}

RoundedRectangleBorder dialogShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);
