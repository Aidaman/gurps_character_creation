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

    if (MediaQuery.of(this).size.width > MAX_MOBILE_WIDTH) {
      return showDialog<T>(
        context: this,
        useRootNavigator: useRootNavigator,
        builder: (context) {
          return Dialog(
            shape: dialogShape,
            insetPadding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: screenHeight / 1.5,
                maxWidth: screenWidth / 3,
                minWidth: screenWidth / 4,
              ),
              child: builder(context),
            ),
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
            maxHeight: MediaQuery.of(context).size.height,
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
