import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:gurps_character_creation/utilities/responsive_layouting_constants.dart';

BoxConstraints defineDialogConstraints(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double maxHeight = MediaQuery.of(context).size.height / 2;

  if (screenWidth > MIN_DESKTOP_WIDTH) {
    return BoxConstraints(
      maxHeight: maxHeight,
      maxWidth: min(screenWidth / 2, MAX_DESKTOP_CONTENT_WIDTH / 2),
      minWidth: min(screenWidth / 2, MAX_DESKTOP_CONTENT_WIDTH / 2),
    );
  }

  if (screenWidth < MIN_DESKTOP_WIDTH && screenWidth > MAX_MOBILE_WIDTH) {
    return BoxConstraints(
      minHeight: maxHeight,
      minWidth: screenWidth / 2,
      maxWidth: screenWidth / 2,
    );
  }

  return BoxConstraints(
    maxHeight: MediaQuery.of(context).size.height - MOBILE_VERTICAL_PADDING,
    maxWidth: screenWidth - MOBILE_HORIZONTAL_PADDING,
    minWidth: screenWidth - MOBILE_HORIZONTAL_PADDING,
  );
}

RoundedRectangleBorder dialogShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(12),
  ),
);
